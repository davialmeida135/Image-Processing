#include "convolutions.h"

// 1. Função de Convolução (Média, Passa-alta, etc)
unsigned char aplicar_convolucao_pixel(Image img, int x, int y, int kernel_size, int *kernel, int soma_pesos_kernel) {
    int k = kernel_size / 2;
    int soma_convolucao = 0;

    for (int i = -k; i <= k; i++) {
        for (int j = -k; j <= k; j++) {
            int img_y = y + i;
            int img_x = x + j;
            int indice_img = img_y * img.width + img_x;
            
            int kern_y = i + k;
            int kern_x = j + k;
            int indice_kernel = kern_y * kernel_size + kern_x;

            soma_convolucao += img.pixels[indice_img] * kernel[indice_kernel];
        }
    }

    int valor_final = soma_convolucao / soma_pesos_kernel;
    
    // Clamping: garante que o valor fique entre 0 e 255
    if (valor_final > 255) valor_final = 255;
    if (valor_final < 0) valor_final = 0;
    
    return (unsigned char)valor_final;
}

// 2. Função de Max Pooling
unsigned char aplicar_max_pooling_pixel(Image img, int x, int y, int kernel_size) {
    int k = kernel_size / 2;
    int valor_maximo = 0; // Inicializa com o menor possível

    for (int i = -k; i <= k; i++) {
        for (int j = -k; j <= k; j++) {
            int img_y = y + i;
            int img_x = x + j;
            int indice_img = img_y * img.width + img_x;
            
            unsigned char pixel_atual = img.pixels[indice_img];
            if (pixel_atual > valor_maximo) {
                valor_maximo = pixel_atual;
            }
        }
    }
    return (unsigned char)valor_maximo;
}

// 3. Função de Min Pooling
unsigned char aplicar_min_pooling_pixel(Image img, int x, int y, int kernel_size) {
    int k = kernel_size / 2;
    int valor_minimo = 255; // Inicializa com o maior possível

    for (int i = -k; i <= k; i++) {
        for (int j = -k; j <= k; j++) {
            int img_y = y + i;
            int img_x = x + j;
            int indice_img = img_y * img.width + img_x;
            
            unsigned char pixel_atual = img.pixels[indice_img];
            if (pixel_atual < valor_minimo) {
                valor_minimo = pixel_atual;
            }
        }
    }
    return (unsigned char)valor_minimo;
}