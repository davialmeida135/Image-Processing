#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STB_IMAGE_IMPLEMENTATION
#include "../stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../stb_image_write.h"

typedef struct
{
    int width;
    int height;
    int max_value;
    unsigned char *pixels;
} Image;

int comparar_pixels(const void *a, const void *b)
{
    return (*(int *)a - *(int *)b);
}

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
    char c = fgetc(image_file);
    while (c == ' ' || c == '\n' || c == '\r' || c == '\t')
        c = fgetc(image_file);
    if (c == '#')
    {
        while (c != '\n' && c != EOF)
            c = fgetc(image_file);
    }
    else
    {
        ungetc(c, image_file);
    }
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

Image readPNG(const char *file_path)
{
    Image img;
    int canais_originais;
    img.pixels = stbi_load(file_path, &img.width, &img.height, &canais_originais, 1);
    if (img.pixels == NULL)
    {
        printf("Erro ao carregar o PNG (%s).\n", file_path);
        exit(1);
    }
    img.max_value = 255;
    return img;
}

void writePNG(const char *file_path, Image img)
{
    int sucesso = stbi_write_png(file_path, img.width, img.height, 1, img.pixels, img.width);
    if (!sucesso)
    {
        printf("Erro ao salvar o arquivo PNG.\n");
        exit(1);
    }
}

int termina_com(const char *string, const char *sufixo)
{
    if (!string || !sufixo)
        return 0;
    size_t len_string = strlen(string);
    size_t len_sufixo = strlen(sufixo);
    if (len_sufixo > len_string)
        return 0;
    return strncmp(string + len_string - len_sufixo, sufixo, len_sufixo) == 0;
}

int main()
{
    const char *arquivo_entrada = "../img/boat_s_and_p.pgm";
    Image img;

    if (termina_com(arquivo_entrada, ".png"))
    {
        printf("Lendo imagem PNG...\n");
        img = readPNG(arquivo_entrada);
    }
    else if (termina_com(arquivo_entrada, ".pgm"))
    {
        printf("Lendo imagem PGM...\n");
        img = readPGM(arquivo_entrada);
    }
    else
    {
        printf("Formato de arquivo nao suportado.\n");
        return 1;
    }

    int kernel_size = 5;
    int k = kernel_size / 2;
    int total_vizinhos = kernel_size * kernel_size;

    Image img_out;
    img_out.width = img.width;
    img_out.height = img.height;
    img_out.max_value = img.max_value;
    img_out.pixels = (unsigned char *)calloc(img.width * img.height, sizeof(unsigned char));

    printf("Aplicando Filtro da Mediana...\n");

    for (int y = k; y < img.height - k; y++)
    {
        for (int x = k; x < img.width - k; x++)
        {

            int vizinhos[kernel_size*kernel_size];
            int contador = 0;

            for (int i = -k; i <= k; i++)
            {
                for (int j = -k; j <= k; j++)
                {
                    int img_y = y + i;
                    int img_x = x + j;
                    int indice_img = img_y * img.width + img_x;

                    vizinhos[contador] = img.pixels[indice_img];
                    contador++;
                }
            }

            qsort(vizinhos, total_vizinhos, sizeof(int), comparar_pixels);

            int indice_do_meio = total_vizinhos / 2;
            int valor_mediana = vizinhos[indice_do_meio];

            int indice_centro = y * img.width + x;
            img_out.pixels[indice_centro] = (unsigned char)valor_mediana;
        }
    }

    if (termina_com(arquivo_entrada, ".png"))
    {
        writePNG("resultado_mediana.png", img_out);
        printf("Salvo como resultado_mediana.png\n");
    }
    else
    {
        writePGM("resultado_mediana.pgm", img_out);
        printf("Salvo como resultado_mediana.pgm\n");
    }

    free(img.pixels);
    free(img_out.pixels);

    return 0;
}