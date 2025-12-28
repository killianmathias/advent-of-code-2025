import fs from "node:fs";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

// Class of a red tile
class RedTile {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

// Function that loads the file and transform it into an array of red tile
async function loadFile(pathname) {
  const filePath = resolve(pathname);
  const content = await readFile(filePath, { encoding: "utf-8" });
  const table = content.split("\n");

  const redTiles = [];
  for (const element of table) {
    const coord = element.split(",");
    redTiles.push(new RedTile(parseInt(coord[0]), parseInt(coord[1])));
  }

  return redTiles;
}

// Function that calculate the biggest area of a rectangle
function calculateMax(redTiles) {
  let max = 0;
  for (let i = 0; i < redTiles.length; i++) {
    for (let j = i + 1; j < redTiles.length; j++) {
      const element = redTiles[i];
      const element2 = redTiles[j];
      const dx = Math.abs(element.x - element2.x);
      const dy = Math.abs(element.y - element2.y);
      const value = (dx + 1) * (dy + 1);
      if (value > max) {
        max = value;
      }
    }
  }

  return max;
}

// Final result
const redTiles = await loadFile("input.txt");
const result = calculateMax(redTiles);
console.log(result);
