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
  const table = content.trim().split("\n");

  const redTiles = [];
  for (const element of table) {
    const coord = element.split(",");
    redTiles.push(new RedTile(parseInt(coord[0]), parseInt(coord[1])));
  }

  return redTiles;
}

// Function that check if the center crosses odd or even number of vertical edge of the polygon into infinity X
function pointInsidePolygon(x, y, polygon) {
  let isInside = false;

  for (let i = 0; i < polygon.length; i++) {
    const current = polygon[i];
    let previous = null;

    if (i == 0) {
      previous = polygon[polygon.length - 1];
    } else {
      previous = polygon[i - 1];
    }

    if (
      ((current.y > y && previous.y <= y) ||
        (previous.y > y && current.y <= y)) &&
      x <
        ((y - current.y) * (previous.x - current.x)) /
          (previous.y - current.y) +
          current.x
    ) {
      isInside = !isInside;
    }
  }

  return isInside;
}

// Function that check if one of the vertical edge of the polygon crosses the rectangle
function polygonCrossesRectangle(minX, maxX, minY, maxY, polygon) {
  for (let i = 0; i < polygon.length; i++) {
    const current = polygon[i];
    let next = null;

    if (i == polygon.length - 1) {
      next = polygon[0];
    } else {
      next = polygon[i + 1];
    }

    if (current.x === next.x) {
      if (current.x > minX && current.x < maxX) {
        const y1 = Math.min(current.y, next.y);
        const y2 = Math.max(current.y, next.y);
        if (y2 > minY && y1 < maxY) {
          return true;
        }
      }
    }

    if (current.y === next.y) {
      if (current.y > minY && current.y < maxY) {
        const x1 = Math.min(current.x, next.x);
        const x2 = Math.max(current.x, next.x);
        if (x2 > minX && x1 < maxX) {
          return true;
        }
      }
    }
  }

  return false;
}

// Function that calculate the biggest rectangle inside the polygon
function calculateMax(redTiles) {
  let max = 0;
  for (let i = 0; i < redTiles.length; i++) {
    for (let j = i + 1; j < redTiles.length; j++) {
      const element = redTiles[i];
      const element2 = redTiles[j];

      const dx = Math.abs(element.x - element2.x) + 1;
      const dy = Math.abs(element.y - element2.y) + 1;
      const value = dx * dy;

      if (value <= max) {
        continue;
      }

      const minX = Math.min(element.x, element2.x);
      const maxX = Math.max(element.x, element2.x);
      const minY = Math.min(element.y, element2.y);
      const maxY = Math.max(element.y, element2.y);

      const centerX = (minX + maxX) / 2;
      const centerY = (minY + maxY) / 2;

      if (pointInsidePolygon(centerX, centerY, redTiles)) {
        if (!polygonCrossesRectangle(minX, maxX, minY, maxY, redTiles)) {
          max = value;
        }
      }
    }
  }

  return max;
}

const redTiles = await loadFile("input.txt");
const result = calculateMax(redTiles);
console.log(result);
