#ifndef CONVOLUTIONS_H
#define CONVOLUTIONS_H

typedef struct
{
    int width;
    int height;
    int max_value;
    unsigned char *pixels;
} Image;

unsigned char aplicar_convolucao_pixel(Image img, int x, int y, int kernel_size, int *kernel, int soma_pesos_kernel);

#endif