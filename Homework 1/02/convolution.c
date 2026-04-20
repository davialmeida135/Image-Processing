#include "convolution.h"

unsigned char aplicar_convolucao_pixel(Image img, int x, int y, int kernel_size, int *kernel, int soma_pesos_kernel)
{
    int k = kernel_size / 2;
    int soma_convolucao = 0;

    for (int i = -k; i <= k; i++)
    {
        for (int j = -k; j <= k; j++)
        {
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
    if (valor_final > 255)
        valor_final = 255;
    if (valor_final < 0)
        valor_final = 0;

    return (unsigned char)valor_final;
}