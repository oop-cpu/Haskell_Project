import java.io.*;
import java.util.*;

public class show{

    // Input screen width and heigth in terms of characters that can be displayed on the terminal
    public static int screen_width  = 155;
    public static int screen_height = 40;

    public static shape[] shapeArr;
    public static int xMax = 0;
    public static int yMax = 0;
    public static void main(String[] args){
        System.out.println("Init::");
        int count = 0;
        try{
            Scanner in = new Scanner(new File("instructions.dat"));
            while(in.hasNextLine()){
                String line = in.nextLine();
                if(line.length() > 0)
                    count++;
            }
        }catch(FileNotFoundException e){System.out.println("Error: " + e);}
        shapeArr = new shape[count];
        try{
            Scanner in = new Scanner(new File("instructions.dat"));
            int counter = 0;
            while(in.hasNextLine()){
                String line = in.nextLine();
                if(line.length() > 0){
                    shapeArr[counter] = parseIn(line);
                    if(shapeArr[counter].x > xMax) xMax = shapeArr[counter].x;
                    if(shapeArr[counter].y > yMax) yMax = shapeArr[counter].y;
                    counter++;
                }
            }
            System.out.println(shapeArr);
        }catch(FileNotFoundException e){System.out.println("Error: " + e);}

        displayManager disp = new displayManager(screen_width, screen_height);

        for(int i = 0; i < shapeArr.length; i++)
            disp.addShape(shapeArr[i]);
        disp.print();
    }

    public static shape parseIn(String line){
        //eq: SI square 2 (0,5)
        Scanner p = new Scanner(line);
        System.out.println("Parsing: " + line);
        p.next();
        String t = p.next();
        System.out.println("    Type: " + t);
        int s = p.nextInt();
        System.out.println("    Size: " + s);

        String coor = p.next();
        char[] chars = coor.toCharArray();
        chars[0] = ' ';
        chars[coor.length()-1] = ' ';
        coor = new String(chars);

        int indexComma = 0;
        for(int i = 0; i < coor.length(); i++)
            if(coor.substring(i, i + 1).equals(","))
                indexComma = i;
        char[] charCoor = coor.toCharArray();
        charCoor[indexComma] = ' ';
        coor = new String(charCoor);

        Scanner cP = new Scanner(coor);
        int x = cP.nextInt();
        int y = cP.nextInt();

        System.out.println("    Coor: (" + x + ", " + y + ")");

        shape re = new shape(t, x, y, s);
        return re;
    }
}
