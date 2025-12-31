#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

struct present{
    int index;
    int width;
    int height;
    std::vector<std::vector<std::string>> variations;
};

struct region{
    int index;
    int width;
    int height;
    std::vector<int> quantities;
};

std::string trim(const std::string& str){
    size_t last = str.find_last_of(" \t\n\r");
    if (last == std::string::npos){
        return "";
    }
    return str.substr(0,last+1);
};

std::vector<std::string> rotate(const std::vector<std::string>& present) {
    if (present.empty()) return {};
    int h = present.size();
    int w = present[0].size();
    
    std::vector<std::string> out(w, std::string(h, ' '));
    
    for (int y = 0; y < h; ++y) {
        for (int x = 0; x < w; ++x) {
            out[x][h - 1 - y] = present[y][x];
        }
    }
    return out;
}

std::vector<std::string> flip(std::vector<std::string> present) {
    for (auto& row : present) {
        std::reverse(row.begin(), row.end());
    }
    return present;
}

void calculate_variation(std::vector<present>& presents){
    for (auto& present: presents){
        std::vector<std::string> initial_variation = present.variations[0];

        present.variations.clear();

        std::vector<std::string> current = initial_variation;
        std::vector<std::string> current_flipped = flip(current);

        for (int i = 0; i < 4; ++i) {
            bool exists = false;
            for (const auto& variation : present.variations) {
                if (variation == current) {
                    exists = true;
                    break; 
                }
            }
            if (!exists){
                present.variations.push_back(current);
            }

            exists = false;
            for (const auto& variation : present.variations) {
                if (variation == current_flipped) {
                    exists = true;
                    break; 
                }
            }
            if (!exists){
                present.variations.push_back(current_flipped);
            }
            current = rotate(current);
            current_flipped = rotate(current_flipped);
        }
    }
}

bool can_fit(std::vector<present> presents, region region){
    if (presents.empty()){
        return true;
    }

    std::vector<present> new_presents = presents;
}

int calculate_solution(std::vector<present> presents, std::vector<region> regions){
    int total = 0;
    for (auto region : regions){
        if (can_fit(presents, region)){
            total++;
        }
    }
    return total;
}
int main() {
    std::vector<present> presents;
    std::vector<region> regions;


    std::ifstream input("input_example.txt");
    if (!input) {
        std::cerr << "Impossible d'ouvrir input.txt\n";
        return 1;
    }

    std::string line;
    while (std::getline(input, line)) {
        if (line.empty()){
            continue;
        }

        if (line.find("x") != std::string::npos) {
            for (char &c : line){
                if (c == 'x' || c == ':'){
                    c = ' ';
                }
            }

            std::stringstream ss(line);
            region r;
            r.index = regions.size();
            ss >> r.width >> r.height;
            
            int q;
            while (ss >> q) {
                r.quantities.push_back(q);
            }
            regions.push_back(r);

        } else if (line.back() == ':') {
            present p;
            p.index = std::stoi(line.substr(0, line.size() - 1));
            p.width = 0;
            p.height = 0;
            p.variations.push_back({});
            presents.push_back(p);

        }else{
            if (!presents.empty()) {
                presents.back().variations[0].push_back(line);
                presents.back().height++;
                presents.back().width = line.size();
            }
        }
    }

    calculate_variation(presents);
    int result = calculate_solution(presents, regions);

    std::cout << result << std::endl;
    return 0;
}