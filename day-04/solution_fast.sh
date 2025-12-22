#!/bin/bash

awk '
BEGIN {
    FS = "" # On sépare chaque caractère comme un champ
}

# 1. Lecture de la grille en mémoire
{
    for (i = 1; i <= NF; i++) {
        grid[NR, i] = $i
    }
    cols = NF # On retient la largeur
}

# 2. Une fois tout le fichier lu
END {
    rows = NR
    total = 0

    # On parcourt chaque cellule
    for (r = 1; r <= rows; r++) {
        for (c = 1; c <= cols; c++) {
            
            # On ne traite que les rouleaux
            if (grid[r, c] == "@") {
                neighbors = 0
                
                # Vérification des 8 voisins
                for (dr = -1; dr <= 1; dr++) {
                    for (dc = -1; dc <= 1; dc++) {
                        # On ignore la case centrale (0,0)
                        if (dr == 0 && dc == 0) continue

                        # Astuce AWK : Si l index n existe pas, il renvoie vide ("")
                        # Donc pas besoin de if compliqué pour tester les bords !
                        if (grid[r + dr, c + dc] == "@") {
                            neighbors++
                        }
                    }
                }

                if (neighbors < 4) {
                    total++
                }
            }
        }
    }
    print total
}
' input.txt