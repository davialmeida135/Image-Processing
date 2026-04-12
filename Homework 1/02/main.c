#include <stdio.h>
#include <stdlib.h>
#include "convolutions.h"

#define LOW_PASS 1
#define HIGH_PASS 2

Image readPGM(const char *file_path)
{
    Image img;
    FILE *image_file = fopen(file_path, "r");

    if (image_file == NULL)
    {
        printf("Erro: Arquivo nao encontrado (%s).\n", file_path);
        exit(1);
    }

    char tipo[3];
    fscanf(image_file, "%2s", tipo);

    // Pula os comentários
    char c = fgetc(image_file);
    while (c == ' ' || c == '\n' || c == '\r' || c == '\t')
    {
        c = fgetc(image_file);
    }
    if (c == '#')
    {
        while (c != '\n' && c != EOF)
        {
            c = fgetc(image_file);
        }
    }
    else
    {
        ungetc(c, image_file);
    }

    // Lê as dimensões
    fscanf(image_file, "%d %d %d", &img.width, &img.height, &img.max_value);

    int total_pixels = img.width * img.height;
    img.pixels = (unsigned char *)malloc(total_pixels * sizeof(unsigned char));

    int valor_temp;
    for (int i = 0; i < total_pixels; i++)
    {
        fscanf(image_file, "%d", &valor_temp);
        img.pixels[i] = (unsigned char)valor_temp;
    }

    fclose(image_file);
    return img;
}

void writePGM(const char *file_path, Image img)
{
    FILE *out_file = fopen(file_path, "w");
    if (out_file == NULL)
    {
        printf("Erro ao criar o arquivo de saida.\n");
        exit(1);
    }

    fprintf(out_file, "P2\n");
    fprintf(out_file, "%d %d\n", img.width, img.height);
    fprintf(out_file, "%d\n", img.max_value);

    int total_pixels = img.width * img.height;
    for (int i = 0; i < total_pixels; i++)
    {
        fprintf(out_file, "%d\n", img.pixels[i]);
    }

    fclose(out_file);
}

int main()
{
    Image img = readPGM("../img/bear_s_and_p.pgm");

    int filtro_aplicado = LOW_PASS;

    int kernel_baixa[] = {
        1, 1, 1,
        1, 1, 1,
        1, 1, 1};
    int soma_pesos_baixa = 9;

    int kernel_alta[] = {
        0, -1, 0,
        -1, 4, -1,
        0, -1, 0};
    int soma_pesos_alta = 1;

    int kernel_size = 3;
    int k = kernel_size / 2;

    Image img_out;
    img_out.width = img.width;
    img_out.height = img.height;
    img_out.max_value = img.max_value;
    img_out.pixels = (unsigned char *)calloc(img.width * img.height, sizeof(unsigned char));

    for (int y = k; y < img.height - k; y++)
    {
        for (int x = k; x < img.width - k; x++)
        {
            int indice_centro = y * img.width + x;

            if (filtro_aplicado == LOW_PASS)
            {
                img_out.pixels[indice_centro] = aplicar_convolucao_pixel(img, x, y, kernel_size, kernel_baixa, soma_pesos_baixa);
            }
            else if (filtro_aplicado == HIGH_PASS)
            {
                img_out.pixels[indice_centro] = aplicar_convolucao_pixel(img, x, y, kernel_size, kernel_alta, soma_pesos_alta);
            }
        }
    }

    if (filtro_aplicado == LOW_PASS)
    {
        writePGM("resultado_low_pass.pgm", img_out);
    }
    else
    {
        writePGM("resultado_high_pass.pgm", img_out);
    }

    free(img.pixels);
    free(img_out.pixels);

    printf("Convolucao concluida com sucesso!\n");
    return 0;
}