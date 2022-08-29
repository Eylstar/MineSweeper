PFont Font1;
float rows = 20;
float lines = 20;
float caseWidth, caseHeight;
int[][] board;
int bombNumberInit = 60;
int bombNumber;
int flagNumber = 0;
boolean bombClicked= false;
color c1 = #1465F2;
color c2 = #27B906;
color c3 = #FF0000;
color c4 = #1708AB;
color c5 = #A93712;

void setup()
{
  size(600,600);
  background(220);
  Font1 = createFont("Arial Bold", 18);
  textFont(Font1);
  textAlign(CENTER, CENTER);
  textSize(15);
  caseWidth = width / rows;
  caseHeight = height / lines;
  board = new int[int(rows)][int(lines)];
  displayGrid();
  bombNumber = bombNumberInit;
  placeBombs();
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j < lines; j++)
    {
      initValues(i, j);
    }
  }
}

void placeBombs()
{
  if(bombNumber > 0)
  {
    int randX = int(random(0, rows));
    int randY = int(random(0,lines));
    if(board[randX][randY] != 9)
    {
      bombNumber--;
      board[randX][randY] = 9;
    }
    placeBombs();
  }
  else return;
}

void initValues(int x, int y)
{
  if(board[x][y] == 9) return;
  int bombsNearby = 0;
  if(x-1 >= 0) if(board[x-1][y] == 9) bombsNearby++;
  if(x+1 < rows) if(board[x+1][y] == 9) bombsNearby++;
  if(y-1 >= 0) if(board[x][y-1] == 9) bombsNearby++;
  if(y+1 < lines) if(board[x][y+1] == 9) bombsNearby++;
  if(y-1 >= 0 && x-1 >= 0) if(board[x-1][y-1] == 9) bombsNearby++;
  if(y+1 < lines && x+1 < rows) if(board[x+1][y+1] == 9) bombsNearby++;
  if(y-1 >= 0 && x+1 < rows) if(board[x+1][y-1] == 9) bombsNearby++;
  if(y+1 < lines && x-1 >= 0) if(board[x-1][y+1] == 9) bombsNearby++;
  board[x][y] = bombsNearby;
}

void draw()
{
  background(190);
  displayGrid();
}

void displayGrid()
{
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j < lines; j++)
    {
      if(bombClicked)
      {
        if(board[i][j] >= 20)
        {
          board[i][j] -= 20;
        }
        if(board[i][j] == 9)
        {
          fill(color(255,0,0));
          rect(caseWidth*i, caseHeight*j, caseWidth, caseHeight);
        }
        if(board[i][j] != 0 && board[i][j] != 10 && board[i][j] != 9)
        {
          fill(220);
          rect(caseWidth*i, caseHeight*j, caseWidth, caseHeight);
        }
        if(board[i][j] > 0 && board[i][j] < 9)
        {
          fill(selectColor(board[i][j]));
          text(board[i][j], i*caseWidth + caseWidth/2, j*caseHeight + caseHeight/2);
        }
        if(board[i][j] > 10 && board[i][j] < 19)
        {
          fill(selectColor(board[i][j]-10));
          text(board[i][j]-10, i*caseWidth + caseWidth/2, j*caseHeight + caseHeight/2);
        }
      }
      else
      {
        if(board[i][j] != 10)
        {
          fill(220);
          rect(caseWidth*i, caseHeight*j, caseWidth, caseHeight);
        }
        if(board[i][j] > 10 && board[i][j] < 19)
        {
          fill(selectColor(board[i][j]-10));
          text(board[i][j]-10, i*caseWidth + caseWidth/2, j*caseHeight + caseHeight/2);
        }
        if(board[i][j] >= 20)
        {
          fill(color(255,0,0));
          ellipse(i*caseWidth + caseWidth/2, j*caseHeight + caseHeight/2, caseWidth / 2, caseHeight /2);
        }
      }
    }
  }
}

color selectColor(int value)
{
  switch(value){
    case 1:
      return c1;
    case 2:
      return c2;
    case 3:
      return c3;
    case 4:
      return c4;
    case 5:
      return c5;
    default:
      return c5;
  }
}

void mousePressed()
{
  int xCase = 0;
  int yCase = 0;
  for(int i = 0; i <= rows; i++)
  {
    if(caseWidth * i > mouseX)
    {
      xCase = i - 1;
      break;
    }
  }
  for(int j = 0; j <= lines; j++)
  {
    if(caseWidth * j > mouseY)
    {
      yCase = j - 1;
      break;
    }
  }
  
  if (mouseButton == LEFT && !bombClicked)   
  {
    if(board[xCase][yCase] == 9)
    {
      bombClicked = true;
    }
    else if(board[xCase][yCase] > 0 && board[xCase][yCase] < 9)
    {
      board[xCase][yCase] += 10;
    }
    else if(board[xCase][yCase] == 0)
    {
      floodFill(xCase, yCase);
    }
  }
  if (mouseButton == RIGHT && !bombClicked)   
  {
    if(board[xCase][yCase] >= 0 && board[xCase][yCase] < 10 && flagNumber < bombNumberInit)
    {
      board[xCase][yCase] += 20;
      flagNumber++;
    }
    else if(board[xCase][yCase] >= 20)
    {
      board[xCase][yCase] -= 20;
      flagNumber--;
    }
  }
}

void floodFill(int x, int y)
{
  if(board[x][y] == 0)
  {
    board[x][y] = 10;
    if(x+1 < rows) floodFill(x+1, y);
    if(x-1 >= 0) floodFill(x-1, y);
    if(y+1 < lines) floodFill(x, y+1);
    if(y-1 >= 0) floodFill(x, y-1);
  }
  else if(board[x][y] > 0 && board[x][y] < 9)
  {
    board[x][y] += 10;
    checkDiagonals();
  }
}

void checkDiagonals()
{
  boolean isCorner = false;
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j < lines; j++)
    {
      if(board[i][j] > 0 && board[i][j] < 9)
      {
        if(j-1 >= 0 && i-1 >= 0 && board[i-1][j-1] == 10) isCorner = true;
        if(j+1 < lines && i+1 < rows && board[i+1][j+1] == 10) isCorner = true;
        if(j-1 >= 0 && i+1 < rows && board[i+1][j-1] == 10) isCorner = true;
        if(j+1 < lines && i-1 >= 0 && board[i-1][j+1] == 10) isCorner = true;
      }
      if(isCorner)
      {
        board[i][j] += 10;
      }
      isCorner = false;
    }
  }
}
