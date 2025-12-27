import java.util.*;
import java.lang.*;
import java.io.IOException;
import java.nio.file.*;

class Segment implements Comparable<Segment>{
    JunctionBox j1,j2;
    double distance ;

    Segment(JunctionBox j1, JunctionBox j2){
        this.j1 = j1;
        this.j2 = j2;
        this.distance = j1.distance(j2);
    }

    @Override
    public int compareTo(Segment other) {
        return Double.compare(this.distance, other.distance);
    }
}
class JunctionBox{
    int x;
    int y;
    int z;
    Circuit circuit;

    JunctionBox(int x, int y, int z){
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Double distance(JunctionBox j2){
        return Math.sqrt(Math.pow(this.x - j2.x,2) + Math.pow(this.y - j2.y,2) + Math.pow(this.z - j2.z,2));
    }

    @Override
    public String toString() {
        return "JunctionBox{" + "x=" + x + ", y=" + y + ", z=" + z + '}';
    }
}

class Circuit{
    Set<JunctionBox> junctionBoxes;

    Circuit(){
        junctionBoxes = new HashSet<>();
    }

    public void add(JunctionBox j){
        junctionBoxes.add(j);
        j.circuit = this;
    }

    public void merge(Circuit c){
        for (JunctionBox j :c.junctionBoxes){
            add(j);
        }
        c.junctionBoxes.clear();
    }
}


public class part1{

    public static List<JunctionBox> open_file(String cheminFichier) {
        List<JunctionBox> junctionBoxes = new ArrayList<>();

        try (var lignes = Files.lines(Paths.get(cheminFichier))) {
            lignes.forEach(line->{
                String[] parts = line.split(",");
                int x =Integer.parseInt(parts[0].trim());
                int y =Integer.parseInt(parts[1].trim());
                int z =Integer.parseInt(parts[2].trim());

                junctionBoxes.add(new JunctionBox(x, y, z));
            });
        } catch (IOException e) {
            System.err.println("Erreur lors de la lecture du fichier : " + e.getMessage());
        }
        return junctionBoxes;
    }

    public static List<Circuit> connect(List<JunctionBox> junctionBoxes, int limit){

        List<Circuit> circuits = new ArrayList<>();
        for (JunctionBox j : junctionBoxes) {
            Circuit c = new Circuit();
            c.add(j);
            circuits.add(c);
        }
        List<Segment> segments = new ArrayList<>();
        for (int i = 0; i < junctionBoxes.size();i++){
            for(int j = i+1; j < junctionBoxes.size();j++){
                segments.add(new Segment(junctionBoxes.get(i), junctionBoxes.get(j)));
            }
        }

        Collections.sort(segments);
        for (int i = 0; i < segments.size() && i <limit; i++){

            Segment s = segments.get(i); 
            Circuit c1 = s.j1.circuit;
            Circuit c2 = s.j2.circuit;

            if (c1 != c2){
                c1.merge(c2);
            }
        }

        Set<Circuit> finalCircuits = new HashSet<>();
        for(JunctionBox j : junctionBoxes){
            finalCircuits.add(j.circuit);
        }

        return new ArrayList<>(finalCircuits);

    }

    public static void main(String[] args) {

        List<JunctionBox> junctionBoxes = open_file("input.txt");

        List<Circuit> circuits = connect(junctionBoxes, 1000);

        circuits.sort((c1,c2)-> Integer.compare(c2.junctionBoxes.size(), c1.junctionBoxes.size()));
        int total = 1;
        if (circuits.size()<=3){
            total=0;
        }else{
            for (int i = 0; i < 3 && i < circuits.size(); i++) {
                total *= circuits.get(i).junctionBoxes.size();
            }
        }
        System.out.println("Final result : " + total);


    }
}