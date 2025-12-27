#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 255

// Function that open a file
FILE* open_file(char* pathname){
    FILE* file = fopen(pathname, "r");
    if (file == NULL){
        fprintf(stderr, "Le fichier n'a pas pu être ouvert\n");
    }
    return file;
}

// Function that calculate the number of splits (the number of time the beam is splitted)
int count_splits(FILE* file){
    int count = 0;
    int index_size = 1;
    int* indexes = malloc(sizeof *indexes);
    char buf[BUFSIZE];
    if(fgets(buf,sizeof buf, file) != NULL){
        int i = 0;
        while (buf[i] != 'S' && buf[i] != '\0'){
            i++;
        }
        if (buf[i]=='S'){
            indexes[0] = i;
        }
    }

    while(fgets(buf, sizeof buf, file) != NULL){
        int new_index_size = 0;
        int *next = NULL;

        for (int i = 0; i < index_size; i++){
            int col = indexes[i];

            if (buf[col]=='^'){
                count++;
                if (col - 1 >= 0){
                    int exists = 0;
                    for (int j = 0; j < new_index_size; j++)
                        if (next[j] == col-1) exists = 1;
                    if (!exists){
                        int* tmp = realloc(next, (new_index_size+1) * sizeof *next);
                        if (!tmp){ free(next); free(indexes); return -1; }
                        next = tmp;
                        next[new_index_size++] = col-1;
                    }
                }
                if (col + 1 < BUFSIZE){
                    int exists = 0;
                    for (int j = 0; j < new_index_size; j++)
                        if (next[j] == col+1) exists = 1;
                    if (!exists){
                        int* tmp = realloc(next, (new_index_size+1) * sizeof *next);
                        if (!tmp){ free(next); free(indexes); return -1; }
                        next = tmp;
                        next[new_index_size++] = col+1;
                    }
                }
            } else {
                int exists = 0;
                for (int j = 0; j < new_index_size; j++)
                    if (next[j] == col) exists = 1;
                if (!exists){
                    int* tmp = realloc(next, (new_index_size+1) * sizeof *next);
                    if (!tmp){ free(next); free(indexes); return -1; }
                    next = tmp;
                    next[new_index_size++] = col;
                }
            }
        }

        free(indexes);
        indexes = next;
        index_size = new_index_size;
    }

    free(indexes);
    return count;
}

// Final result
int main(){
    FILE* file = open_file("input.txt");
    if (file == NULL){
        fprintf(stderr, "Le fichier est null\n");
        return EXIT_FAILURE;
    }
    int count = count_splits(file);
    fprintf(stdout, "count : %d\n", count);
    if (fclose(file)==EOF){
        printf("Erreur lors de la fermeture du flux\n");
        return EXIT_FAILURE;
    }
    return 0;
}