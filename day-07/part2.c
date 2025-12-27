#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE 255

// Function that open a file
FILE* open_file(char* pathname){
    FILE* file = fopen(pathname, "r");
    if (file == NULL){
        fprintf(stderr, "Le fichier n'a pas pu être ouvert\n");
    }
    return file;
}

// Function that counts the number of timelines possible
unsigned long long count_splits(FILE* file){
    unsigned long long count = 0;
    unsigned long long* paths = calloc(BUFSIZE, sizeof *paths);
    char buf[BUFSIZE];

    if(fgets(buf,sizeof buf, file) != NULL){
        int i = 0;
        while (buf[i] != 'S' && buf[i] != '\0'){
            i++;
        }
        if (buf[i]=='S'){
            paths[i] = 1;
        }
    }

    while(fgets(buf, sizeof buf, file) != NULL){
        unsigned long long *next = calloc(BUFSIZE, sizeof *next);

        for (int i = 0; i < BUFSIZE; i++){
            if (paths[i] > 0){
                if (buf[i]=='^'){
                    if (i - 1 >= 0){
                        next[i-1] += paths[i];
                    }
                    if (i + 1 < BUFSIZE){
                        next[i+1] += paths[i];
                    }
                } else if (buf[i] != ' ' && buf[i] != '\n' && buf[i] != '\0'){
                    next[i] += paths[i];
                }
            }
        }

        free(paths);
        paths = next;
    }
    
    for (int i = 0; i < BUFSIZE; i++){
        count += paths[i];
    }
    
    free(paths);
    return count;
}

// Final result
int main(){
    FILE* file = open_file("input_example.txt");
    if (file == NULL){
        fprintf(stderr, "Le fichier est null\n");
        return EXIT_FAILURE;
    }
    unsigned long long count = count_splits(file);
    fprintf(stdout, "count : %llu\n", count);
    if (fclose(file)==EOF){
        printf("Erreur lors de la fermeture du flux\n");
        return EXIT_FAILURE;
    }
    return 0;
}