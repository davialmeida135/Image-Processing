#ifndef CONVOLUTIONS_H
#define CONVOLUTIONS_H

// A estrutura precisa estar aqui para que as funções saibam o que é "Image"
typedef struct {
    int width;
    int height;
    int max_value;
    unsigned char *pixels;
} Image;

// Protótipos das funções que calculam o valor de um único pixel
unsigned char aplicar_convolucao_pixel(Image img, int x, int y, int kernel_size, int *kernel, int soma_pesos_kernel);
unsigned char aplicar_max_pooling_pixel(Image img, int x, int y, int kernel_size);
unsigned char aplicar_min_pooling_pixel(Image img, int x, int y, int kernel_size);

#endif