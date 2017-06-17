package cz.dusanrychnovsky.knightstour;

import java.util.*;

import static java.lang.String.format;
import static java.util.Arrays.asList;
import static java.util.Comparator.comparingInt;

public class Main {
  
  public static void main(String[] args) {
    System.out.println(new Strategy().getTour(new Position(0, 0)).get());
  }
  
  static class Strategy {
    public Optional<Situation> getTour(Position from) {
      return getTour(new Situation(from));
    }
  
    private Optional<Situation> getTour(Situation situation) {
      if (situation.isFinal()) {
        return Optional.of(situation);
      }
      else {
        Set<Position> moves = situation.getValidMoves();
        List<Position> sortedMoves = sort(moves, situation);
        for (Position move : sortedMoves) {
          Optional<Situation> subResult = getTour(situation.applyMove(move));
          if (subResult.isPresent()) {
            return subResult;
          }
        }
        return Optional.empty();
      }
    }
  
    private static List<Position> sort(Set<Position> moves, Situation situation) {
      List<Position> list = new ArrayList<>(moves);
      list.sort(comparingInt(
        position -> situation.applyMove(position).getValidMoves().size())
      );
      return list;
    }
  }
  
  static class Situation {
  
    private final List<Position> moves;
    
    public Situation(List<Position> moves) {
      check(!moves.isEmpty(), "Empty situations are not supported.");
      this.moves = new ArrayList<>();
      for (Position move : moves) {
        check(!this.moves.contains(move), "Multiple steps on field [" + move + "] are not supported");
        this.moves.add(move);
      }
    }
    
    public Situation(Position... moves) {
      this(asList(moves));
    }
  
    public boolean isFinal() {
      return moves.size() == 64;
    }
    
    public Set<Position> getValidMoves() {
      Set<Position> result = new HashSet<>();
      for (Position move : Position.getValidMoves(getLastMove())) {
        if (isValidMove(move)) {
          result.add(move);
        }
      }
      return result;
    }
  
    private boolean isValidMove(Position move) {
      return !moves.contains(move);
    }
  
    private Position getLastMove() {
      return moves.get(moves.size() - 1);
    }
  
    public Situation applyMove(Position pos) {
      return new Situation(concat(moves, pos));
    }
  
    private static <T> List<T> concat(List<T> list, T item) {
      List<T> result = new ArrayList<>();
      result.addAll(list);
      result.add(item);
      return result;
    }
  
    private Map<Position, Integer> asMap() {
      Map<Position, Integer> result = new HashMap<>();
      int i = 1;
      for (Position move : moves) {
        result.put(move, i);
        i++;
      }
      return result;
    }
    
    @Override
    public int hashCode() {
      return moves.hashCode();
    }
  
    @Override
    public boolean equals(Object obj) {
      return
        obj instanceof Situation &&
        moves.equals(((Situation) obj).moves);
    }
  
    @Override
    public String toString() {
      Map<Position, Integer> map = asMap();
      StringBuilder builder = new StringBuilder();
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          Integer turn = map.get(new Position(row, col));
          if (turn != null) {
            builder.append(format("%1$3s", turn));
          } else {
            builder.append("   ");
          }
        }
        builder.append("\n");
      }
      return builder.toString();
    }
  }
  
  static class Position {
  
    private static final List<Offset> OFFSETS = asList(
      new Offset(-2, -1),
      new Offset(-1, -2),
      new Offset(+1, -2),
      new Offset(+2, -1),
      new Offset(+2, +1),
      new Offset(+1, +2),
      new Offset(-1, +2),
      new Offset(-2, +1)
    );
    
    private final int row;
    private final int col;
    
    public Position(int row, int col) {
      check(row >= 0 && row < 8, "Expected 0 <= row < 8, got [" + row + "]");
      check(col >= 0 && col < 8, "Expected 0 <= col < 8, got [" + col + "]");
      this.row = row;
      this.col = col;
    }
    
    public static Set<Position> getValidMoves(Position from) {
      Set<Position> result = new HashSet<>();
      for (Offset offset : OFFSETS) {
        int newRow = from.row + offset.row;
        int newCol = from.col + offset.col;
        if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
          result.add(new Position(newRow, newCol));
        }
      }
      return result;
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
  
  static class Offset {
    
    private final int row;
    private final int col;
    
    public Offset(int row, int col) {
      this.row = row;
      this.col = col;
    }
    
    public int getRow() {
      return row;
    }
    
    public int getCol() {
      return col;
    }
  }
  
  private static void check(boolean cond, String message) {
    if (!cond) {
      throw new AssertionError(message);
    }
  }
}
