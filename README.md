
![R](https://img.shields.io/badge/language-R-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

# 📦 Denoising Autoencoders in R (Keras/TensorFlow)

> Denoising di immagini mediante reti neurali convoluzionali (AutoEncoder) implementate in R, usando `keras` e `tensorflow` con supporto GPU.

Questo progetto mostra come realizzare un modello di autoencoder per il denoising di immagini contaminate da **rumore gaussiano**, con dataset `MNIST` (immagini BW) e `CIFAR-10` (immagini RGB).
In particolare si tratta del frutto del lavoro di alcuni mesi, per la preparazione dell'esame di un corso universitario.

---

## 🔍 Overview

- Linguaggio: **R**
- Framework: **Keras + TensorFlow**
- Architettura: **AutoEncoder convoluzionale simmetrico**
- Dataset:
  - [MNIST](http://yann.lecun.com/exdb/mnist/) (28×28 BW)
  - [CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html) (32×32 RGB)
- Rumore: **Gaussian Noise**, con vari livelli di σ
- Metriche di valutazione: **PSNR** e **SSIM**
- Obiettivo: restituire immagini ricostruite con alta fedeltà rispetto all’originale

---

## ⚙️ Requisiti

Assicurati di avere:

- **R ≥ 4.3**
- **Conda** con un environment R + TensorFlow
- GPU con supporto CUDA (opzionale, ma consigliato per un allenamento della rete più veloce)
  
---

## 🧠 Modello di AutoEncoder

Il modello è composto da:

- **Encoder**: 3 convoluzioni + max pooling
- **Dropout**: diminuizione del rischio di overfitting
- **Latent space**
- **Decoder**: 3 convoluzioni trasposte + upsampling
- **Output**: `tanh`, immagini normalizzate in `[-1, 1]`

---

## 🖼️ Risultati visivi



---

## 📈 Risultati durante sperimentazioni

| Dataset   | Sigma (σ) | PSNR     | Epochs |
|-----------|------------|----------|--------|
| MNIST     | 0.1        | 33.66 dB | 118    |
| MNIST     | 0.25       | 29.66 dB | 256    |
| MNIST     | 0.5        | 26.47 dB | 175    |
| CIFAR-10  | 0.1        | 28.44 dB | 169    |
| CIFAR-10  | 0.25       | 26.63 dB | 200    |
| CIFAR-10  | 0.5        | 24.26 dB | 129    |

> ⚠️ I valori sono mediati su 10.000 immagini test, calcolati tramite `mean PSNR`

---

## 📂 Struttura del repository

```
.
├── mnist_denoising.R
├── cifar10_denoising.R
├── utils/
│   ├── preprocessing.R
│   └── metrics.R
├── results/
│   ├── plots/
│   └── samples/
├── LICENSE
└── README.md

```

> Per questo progetto è stato elaborato anche un report/tesina, con presentazione. Entrambi omessi.

---

### Setup hardware e ambiente

- GPU: **NVIDIA RTX 4070 Super**
- CPU: Intel Core i5 14600KF
- Training time MNIST: ~8ms/step
- Others: CUDA e CUdnn

---

## 📄 Licenza

Questo progetto è distribuito sotto licenza **MIT**. Vedi il file [LICENSE](LICENSE) per i dettagli.
