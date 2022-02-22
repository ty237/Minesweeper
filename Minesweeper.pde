import de.bezier.guido.*;
final int NUM_ROWS = 9;
final int NUM_COLS = 9;
final bool gameEnd = false;
final int numMines = 5;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons;  //2d array of minesweeper buttons
private ArrayList<MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] =  new MSButton(r, c);
      }
    }
    
    setMines();
}
public void setMines()
{
  for (int i = 0; i < numMines; i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
    if (gameEnd) noLoop();
    background( 0 );
    if(isWon() == true)
           gameEnd = true;
           for (int cuRow = 0; cuRow < buttons.length; cuRow++) {
              for (int cuCol = 0; cuCol < buttons[cuRow].length; cuCol++) {
                buttons[cuRow][cuCol].unFlag();
              }
            }
        displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c  = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].isFlagged() != true) {
        return false;
      } else if (!mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
    buttons[0][0].setLabel("Y");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("U");
    buttons[0][3].setLabel("");
    buttons[0][4].setLabel("L");
    buttons[0][5].setLabel("O");
    buttons[0][6].setLabel("S");
    buttons[0][7].setLabel("E");
    buttons[0][8].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[0][0].setLabel("C");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("N");
    buttons[0][3].setLabel("G");
    buttons[0][4].setLabel("R");
    buttons[0][5].setLabel("A");
    buttons[0][6].setLabel("T");
    buttons[0][7].setLabel("S");
    buttons[0][8].setLabel("!");
}
public boolean isValid(int row, int col)
{
  if (row < NUM_ROWS && col < NUM_COLS && row >= 0 && col >= 0) return true;
  return false;
}
public int countMines(int row, int col)
{
  int count = 0;
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c <= col+1; c++) {
      if (r != row || c != col) {
        if (isValid(r, c)) {
          if (mines.contains(buttons[r][c])) count++;
        }
      }
    }
  }
  return count;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    
    public void click() {
      clicked = true;
    }
    
    public void unFlag() {
      flagged = false;
    }

    public boolean isClicked() {
      return clicked;
    }
    // called by manager
    public void mousePressed () 
    {
      if(mouseButton==LEFT)
        {
            clicked = true;
        }
        int r = myRow;
        int c = myCol;
        if(mouseButton==RIGHT)
            flagged=!flagged;
        else if(mines.contains(this)) {
            for (int cuRow = 0; cuRow < buttons.length; cuRow++) {
              for (int cuCol = 0; cuCol < buttons[cuRow].length; cuCol++) {
                buttons[cuRow][cuCol].unFlag();
                buttons[cuRow][cuCol].click();
              }
            }
            gameEnd = true;
            displayLosingMessage();
        }
        else if(countMines(r,c)>0)
            setLabel(countMines(r,c)+"");
        else if(countMines(r,c)==0){
          for (int newR = r-1; newR <= r+1; newR++) {
            for (int newC = c-1; newC <= c+1; newC++) {
              if (newR != r || newC != c) {
                if(isValid(newR,newC) && !buttons[newR][newC].isClicked()) {
                  buttons[newR][newC].mousePressed();
                }
              }
            }
          }
        }
    }
    public void draw () 
    {    
      
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
