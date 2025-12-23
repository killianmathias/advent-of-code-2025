use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashSet;

fn read_file() -> io::Result<(Vec<String>, Vec<String>)> {
    let path = Path::new("input.txt");
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    let mut lines = Vec::new();
    let mut ranges = Vec::new();

    for line in reader.lines() {
        let line = line?;
        if line.contains('-') {
            ranges.push(line);
        } else {
            lines.push(line);
        }
    }

    Ok((lines, ranges))
}

// fn is_under_range(number: i64, ranges: &Vec<String>) -> bool {
//     for range in ranges {
//         let new_range: Vec<&str> = range.split('-').collect();
//         let first = new_range[0].trim().parse::<i64>().unwrap();
//         let second = new_range[1].trim().parse::<i64>().unwrap();

//         if number >= first && number <= second {
//             return true;
//         }
//     }
//     false
// }

// fn count_fresh(lines: &Vec<String>, ranges: &Vec<String>) -> i64 {
//     let mut nb_fresh = 0;

//     for line in lines {
//         if (line != ""){
//             let number = line.trim().parse::<i64>().unwrap();
//             if is_under_range(number, ranges) {
//                 nb_fresh += 1;
//             }
//         }
//     }

//     nb_fresh
// }

fn create_new_ranges(ranges : &Vec<String>) -> Vec<(i64,i64)>{
    let mut new_ranges = Vec::new();
    for range in ranges{
        let new_range: Vec<&str> = range.split('-').collect();
        let first = new_range[0].trim().parse::<i64>().unwrap();
        let second = new_range[1].trim().parse::<i64>().unwrap();
        new_ranges.push((first, second));
    }
    new_ranges
}

fn count_fresh(ranges : &Vec<String>) -> i64{
    let mut new_ranges = create_new_ranges(ranges);

    new_ranges.sort_by_key(|(first,_)|*first);
    let mut nb_fresh = 0;
    let mut current_first = new_ranges[0].0;
    let mut current_second = new_ranges[0].1;

    for &(first,second) in &new_ranges[1..]{
        if (first <= current_second){
            current_second = current_second.max(second);
        }else{
            nb_fresh+= current_second - current_first + 1;
            current_first = first;
            current_second = second;
        }
    }
    nb_fresh += current_second - current_first + 1;
    nb_fresh
}

fn main() -> io::Result<()> {
    let (lines, ranges) = read_file()?;
    let fresh = count_fresh(&ranges);

    println!("Considered fresh number = {}", fresh);

    Ok(())
}