
---
layout: default
title: Denoising Autoencoders in R
---

# 📦 Denoising Autoencoders in R (Keras/TensorFlow)

> Denoising di immagini mediante reti neurali convoluzionali (AutoEncoder) implementate in R, usando `keras` e `tensorflow` con supporto GPU.
> Progetto accademico per un esame universitario (Statistica e Machine Learning - Università degli Studi della Basilicata)

---

## 🔍 Overview

Modello di autoencoder convoluzionale simmetrico per il denoising di immagini affette da rumore gaussiano additivo, sperimentato su dataset MNIST e CIFAR-10.

Tecnologie:
- **R** con `keras` e `tensorflow`
- **GPU**: NVIDIA RTX 4070 Super
- Metriche: **PSNR**, **SSIM**
- Rumore: Gaussian Noise (σ = 0.1–0.392)

---

## 🖼️ Risultati Visivi

### MNIST - σ = 0.392 - PSNR = 26.47 dB
<img src="results/26,47dB-0,392.png" width="400"/>

### CIFAR-10 - σ = 0.392 - PSNR = 24.32 dB
<img src="results/24,32dB-0,392-Cifar10.png" width="400"/>

---

## 📈 Risultati Quantitativi

| Dataset   | Sigma (σ) | PSNR     | Epochs |
|-----------|------------|----------|--------|
| MNIST     | 0.1        | 33.66 dB | 118    |
| MNIST     | 0.196      | 29.66 dB | 256    |
| MNIST     | 0.392      | 26.47 dB | 175    |
| CIFAR-10  | 0.1        | 28.44 dB | 169    |
| CIFAR-10  | 0.196      | 26.63 dB | 200    |
| CIFAR-10  | 0.392      | 24.32 dB | 129    |

---

## 🔗 Repository GitHub

👉 [Vai al repository](https://github.com/gabrielelobosco/denoising-autoencoder-r)

---

## 📄 Licenza

Questo progetto è distribuito sotto licenza **MIT**.
