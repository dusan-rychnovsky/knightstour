package cz.dusanrychnovsky.knightstour;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static cz.dusanrychnovsky.knightstour.Util.check;
import static java.util.Arrays.asList;

public class Board {

  private static final List<Move> KNIGHT_MOVES = asList(
    new Move(-2, -1),
    new Move(-1, -2),
    new Move(+1, -2),
    new Move(+2, -1),
    new Move(+2, +1),
    new Move(+1, +2),
    new Move(-1, +2),
    new Move(-2, +1)
  );

  private final int width;
  private final int height;

  public Board(int width, int height) {
    this.width = width;
    this.height = height;
  }

  public int getWidth() {
    return width;
  }

  public int getHeight() {
    return height;
  }

  public int getSize() {
    return width * height;
  }

  public Position getPosition(int row, int col) {
    check(row >= 0 && row < height, "Expected 0 <= row < " + height + ", got [" + row + "]");
    check(col >= 0 && col < width, "Expected 0 <= col < " + width + ", got [" + col + "]");
    return new Position(row, col);
  }

  public Set<Position> getValidMoves(Position from) {
    Set<Position> result = new HashSet<>();
    for (Move move : KNIGHT_MOVES) {
      int newRow = from.row + move.getVertical();
      int newCol = from.col + move.getHorizontal();
      if (newRow >= 0 && newRow < height && newCol >= 0 && newCol < width) {
        result.add(new Position(newRow, newCol));
      }
    }
    return result;
  }

  public static class Position {

    private final int row;
    private final int col;

    private Position(int row, int col) {
      this.row = row;
      this.col = col;
    }

    public int getRow() {
      return row;
    }

    public int getCol() {
      return col;
    }

    @Override
    public int hashCode() {
      return row + col;
    }

    @Override
    public boolean equals(Object obj) {
      return
        obj instanceof Position &&
          ((Position) obj).row == row &&
          ((Position) obj).col == col;
    }

    public String toString() {
      return "[" + row + ", " + col + "]";
    }
  }

  private static class Move {

    private final int vertical;
    private final int horizontal;

    public Move(int vertical, int horizontal) {
      this.vertical = vertical;
      this.horizontal = horizontal;
    }

    public int getVertical() {
      return vertical;
    }

    public int getHorizontal() {
      return horizontal;
    }
  }
}
