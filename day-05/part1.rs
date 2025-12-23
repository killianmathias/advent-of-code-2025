use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

// Function that read a file and transform it into 2 arrays of String
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

// Function that look if a number is at least in one interval
fn is_under_range(number: i64, ranges: &Vec<String>) -> bool {
    for range in ranges {
        let new_range: Vec<&str> = range.split('-').collect();
        let first = new_range[0].trim().parse::<i64>().unwrap();
        let second = new_range[1].trim().parse::<i64>().unwrap();

        if number >= first && number <= second {
            return true;
        }
    }
    false
}

// Function that count the number of values that are in the intervals
fn count_fresh(lines: &Vec<String>, ranges: &Vec<String>) -> i64 {
    let mut nb_fresh = 0;

    for line in lines {
        if (line != ""){
            let number = line.trim().parse::<i64>().unwrap();
            if is_under_range(number, ranges) {
                nb_fresh += 1;
            }
        }
    }

    nb_fresh
}

// Final result
fn main() -> io::Result<()> {
    let (lines, ranges) = read_file()?;

    let fresh = count_fresh(&lines, &ranges);

    println!("Fresh number = {}", fresh);

    Ok(())
}