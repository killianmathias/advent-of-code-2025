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
        $ligne = rtrim($ligne);
        if ($ligne !== '') {
            $lignes[] = $ligne;
        }
    }

    fclose($flux);
}

// Function that transform the array of String into two arrays : the operations and an array with numbers taken by column
function transform_into_arrays()
{
    global $lignes, $numbers, $operations;
    $ligne_operations = array_pop($lignes);
    $operations = array_reverse(preg_split('/\s+/', $ligne_operations));
    $grid = [];
    $max_length = strlen($lignes[0]);
    foreach ($lignes as $ligne) {
        $length = strlen($ligne);
        $max_length = max($max_length, $length);
    }

    foreach ($lignes as $index => $ligne) {
        $grid[$index] = str_split(str_pad($ligne, $max_length, " "));
    }
    $i = 0;
    for ($column = $max_length - 1; $column >= 0; $column--) {
        $str = "";
        foreach ($lignes as $index => $ligne) {
            $str .= $grid[$index][$column];
        }

        $str_trim = trim($str);
        if ($str_trim != "") {
            $numbers[$i][] = (int) $str_trim;
        } else {
            $i++;
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