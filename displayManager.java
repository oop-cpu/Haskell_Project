public class displayManager{

    public static int x;
    public static int y;

    public static char[][] map;

    public static char empty = ' ';
    public static char pix   = 'O';

    public displayManager(int xx, int yy){
        x = xx;
        y = yy;
        map = new char[y][x];
        clearMap();
    }

    public static void addShape(shape SI){
        if(SI.type.equals("square"))
            addSquare(SI.size, SI.x, SI.y);
        if(SI.type.equals("circle"))
            addCircle(SI.size, SI.x, SI.y);
        if(SI.type.equals("triangle"))
            addTriangle(SI.size, SI.x, SI.y);
    }

    public static void addSquare(int size, int xVal, int yVal){
        int sX = xVal - size;
        int sY = yVal - size;

        int sXMax = sX + size*2;
        int sYMax = sY + size*2;

        while(sX < sXMax){
            addPix(sX, sY);
            addPix(sX, sYMax);
            sX++;
        }

        while(sY < sYMax + 1){
            addPix(sX - size*2, sY);
            addPix(sX, sY);
            sY++;
        }
    }
    public static void addTriangle(int size, int xVal, int yVal){
        int top = yVal - size;
        int bottom = yVal + size - 1;
        int layer = 0;
        for(int i = top; i < bottom; i++){
            if(i == top)
                addPix(xVal, i);
            if(i == bottom-1)
                for(int o = xVal - size; o <= xVal + size; o++)
                    addPix(o, i);
            addPix(xVal - layer, i);
            addPix(xVal + layer, i);
            layer++;
        }
    }
    public static void addCircle(int r, int xc, int yc){
        int x = 0, y = r;
        int d = 3 - 2 * r;
        drawCircle(xc, yc, x, y);
        while (y >= x){
            if (d > 0) {
                y--;
                d = d + 4 * (x - y) + 10;
            }
            else
                d = d + 4 * x + 6;
            x++;
            drawCircle(xc, yc, x, y);
        }
    }
    public static void drawCircle(int xc, int yc, int x, int y){
        addPix(xc+x, yc+y);
        addPix(xc-x, yc+y);
        addPix(xc+x, yc-y);
        addPix(xc-x, yc-y);
        addPix(xc+y, yc+x);
        addPix(xc-y, yc+x);
        addPix(xc+y, yc-x);
        addPix(xc-y, yc-x);
    }

    public static void addPix(int xx, int yy){
        if(yy >= 0 && yy < y && xx >= 0 && xx < x)
            map[yy][xx] = pix;
    }
    public static void clearMap(){
        for(int yy = 0; yy < y; yy++)
            for(int xx = 0; xx < x; xx++)
                map[yy][xx] = empty;
    }

    public static void print(){
        System.out.print("\033[H\033[2J");
        for(int yy = 0; yy < y; yy++){
            for(int xx = 0; xx < x; xx++){
                System.out.print(map[yy][xx]);
            }
            System.out.println();
        }
    }
}
