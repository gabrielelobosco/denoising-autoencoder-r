# =============================
# 1. LIBRARIES IMPORT
# =============================

library(keras)
library(tensorflow)
library(SpatialPack) # SSIM

# =============================
# 2. DATASET IMPORT
# =============================

dataset = dataset_cifar10()

x_train = dataset$train$x
x_test = dataset$test$x

# =============================
# 3. DATASET PRE-ELABORATION
# =============================

# Dataset Reshaping
x_train = array_reshape(x_train, c(nrow(x_train), 32, 32, 3))
x_test = array_reshape(x_test, c(nrow(x_test), 32, 32, 3))

# Image Normalization
x_train = (x_train / 127.5) - 1
x_test = (x_test / 127.5) - 1

# Seed to allow reproducibility
set.seed(102)

# Function to add the Gaussian Noise
add_noise <- function(x, sigma = 0.392) {
  noise <- array(rnorm(length(x), mean = 0, sd = sigma), dim = dim(x))
  return(x + noise)
}

x_train_noisy = add_noise(x_train)
x_test_noisy = add_noise(x_test)

# =============================
# 4. MODEL CONSTRUCTION
# =============================

model <- keras_model_sequential() %>%
  # Encoding
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu", padding = "same", input_shape = c(32, 32, 3)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu", padding = "same") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu", padding = "same") %>%
  # Latent Space
  layer_dropout(rate = 0.25) %>%
  # Decoding
  layer_conv_2d_transpose(filters = 128, kernel_size = c(3, 3), activation = "relu", padding = "same") %>%
  layer_upsampling_2d(size = c(2, 2)) %>%
  layer_conv_2d_transpose(filters = 64, kernel_size = c(3, 3), activation = "relu", padding = "same") %>%
  layer_upsampling_2d(size = c(2, 2)) %>%
  layer_conv_2d_transpose(filters = 32, kernel_size = c(3, 3), activation = "relu", padding = "same") %>%
  # Output Layer
  layer_conv_2d(filters = 1, kernel_size = c(3, 3), activation = "tanh", padding = "same")
summary(model)

# =============================
# 5. METRICS DEFINITIONS
# =============================

psnr <- function(original, denoised, max_value = 2) {
  mse <- mean((original - denoised)^2)
  psnr_value <- 10 * log10((max_value^2) / mse)
  return(psnr_value)
}

# =============================
# 6. COMPILING AND TRAINING
# =============================

model %>% compile(
  loss = "mean_squared_error",
  optimizer = optimizer_adam(learning_rate = 0.00005),
  metrics = c(psnr = psnr)  
)

callbacks = list(
  callback_early_stopping(monitor="val_loss", patience = 5, verbose = 1, restore_best_weights = TRUE)
)

history = model %>% fit(
  x_train_noisy, x_train,
  epochs = 500,
  batch_size = 128,
  validation_data = list(x_test_noisy, x_test),
  callbacks = callbacks
)

# =============================
# 7. EVALUATION AND PREDICTIONS
# =============================

model %>% evaluate(x_test_noisy, x_test)
predictions = model %>% predict(x_test_noisy)

# =============================
# 8. PSNR AND SSIM MEANS ON 10k
# =============================

psnrs = sapply(1:10000, function(i)
  psnr(x_test[i,,,1], predictions[i,,,1]))
print(paste("PSNR on 10000:", mean(psnrs)))

ssims = sapply(1:10000, function(i)
  SSIM(x_test[i,,,1], predictions[i,,,1])$SSIM)
print(paste("SSIM on 10000:", mean(ssims)))

# =============================
# 9. VISUAL COMPARISON
# =============================

indici = sample(1:dim(x_test)[1], 3)
par(mfrow = c(3, 3))
for (i in indici) {
  # Original Image
  image(x_test[i, , ,1], col = gray.colors(256), axes = FALSE)
  title("Original")
  # Nosiy Image
  image(x_test_noisy[i, , ,1], col = gray.colors(256), axes = FALSE)
  title("Noisy") 
  # Denoised Image
  image(predictions[i, , ,1], col = gray.colors(256), axes = FALSE)
  title(sprintf("Denoised - PSNR: %.2f dB", psnr(x_test[i,,,1], predictions[i,,,1]))
}

# =============================
# 10. DESCRIPTIVE ANALYSIS
# =============================

par(mfrow = c(2,2))

hist(psnrs, main = "PSNR Distribution", xlab = "PSNR", col = "lightblue", border = "black", probability = TRUE, ylim = c(0,0.3))
density_psnr = density(psnrs)
lines(density_psnr, col = "blue", lwd = 2)

hist(ssims, main = "SSIM Distribution", xlab = "SSIM", col = "pink", border = "black", probability = TRUE, ylim = c(0, 8000))
density_ssim = density(ssims)
lines(density_ssim, col ="purple", lwd = 2)
               
boxplot(psnrs, main = "PSNR Boxplot", ylab = "PSNR")
boxplot(ssims, main = "SSIM Boxplot", ylab = "SSIM")
