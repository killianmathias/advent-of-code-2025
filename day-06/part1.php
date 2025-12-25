<?php

$lignes = [];
$numbers = [];
$operations = [];
$total = 0;

// Function that loads the file and transform it into an array of String
function load_file()
{
    global $lignes;

    $filepath = 'input.txt';
    $flux = fopen($filepath, 'r');

    if ($flux === false) {
        die('Impossible d’ouvrir le fichier.');
    }

    while (($ligne = fgets($flux)) !== false) {
        $ligne = trim($ligne);
        if ($ligne !== '') {
            $lignes[] = $ligne;
        }
    }

    fclose($flux);
}

// Transform the array of String into two arrays : the operations and an array with numbers
function transform_into_arrays()
{
    global $lignes, $numbers, $operations;

    $ligne_operations = array_pop($lignes);
    $operations = preg_split('/\s+/', $ligne_operations);

    foreach ($lignes as $ligne) {
        $valeurs = preg_split('/\s+/', $ligne);
        foreach ($valeurs as $i => $valeur) {
            $numbers[$i][] = (int) $valeur;
        }
    }
    var_dump($numbers);
}

// Function that calculate the sum of all the operation by column of numbers
function calculate_total()
{
    global $total, $numbers, $operations;

    for ($i = 0; $i < count($numbers); $i++) {
        $number = 0;
        if ($operations[$i] == "*") {
            $number = 1;
            for ($j = 0; $j < count($numbers[$i]); $j++) {
                $number *= $numbers[$i][$j];
            }
        } else {
            for ($j = 0; $j < count($numbers[$i]); $j++) {
                $number += $numbers[$i][$j];
            }
        }
        $total += $number;
    }
}

// Final result
load_file();
transform_into_arrays();
calculate_total();

echo "Final result : " . $total;