package cz.dusanrychnovsky.knightstour;

import cz.dusanrychnovsky.knightstour.Board.Position;

import java.util.*;

import static cz.dusanrychnovsky.knightstour.Util.check;
import static java.lang.String.format;
import static java.util.Arrays.asList;
import static java.util.Comparator.comparingInt;

public class Main {
  
  public static void main(String[] args) {

    Strategy strategy = new Strategy(new Board(4, 3));
    Optional<Tour> tour = strategy.getTour(0, 0);

    if (tour.isPresent()) {
      System.out.println("TOUR:");
      System.out.println(tour.get());
    }
    else {
      System.out.println("TOUR DOES NOT EXIST.");
    }
  }
  
  static class Strategy {

    private final Board board;

    public Strategy(Board board) {
      this.board = board;
    }

    public Optional<Tour> getTour(int row, int col) {
      return getTour(new Tour(board, board.getPosition(row, col)));
    }
  
    private Optional<Tour> getTour(Tour tour) {
      if (tour.isFinished()) {
        return Optional.of(tour);
      }
      else {
        Set<Position> moves = tour.getValidMoves();
        List<Position> sortedMoves = sort(moves, tour);
        for (Position move : sortedMoves) {
          Optional<Tour> subResult = getTour(tour.applyMove(move));
          if (subResult.isPresent()) {
            return subResult;
          }
        }
        return Optional.empty();
      }
    }
  
    private static List<Position> sort(Set<Position> moves, Tour tour) {
      List<Position> list = new ArrayList<>(moves);
      list.sort(comparingInt(
        position -> tour.applyMove(position).getValidMoves().size())
      );
      return list;
    }
  }
  
  static class Tour {

    private final Board board;
    private final List<Position> steps;
    
    public Tour(Board board, List<Position> steps) {
      check(!steps.isEmpty(), "Empty situations are not supported.");
      this.board = board;
      this.steps = new ArrayList<>();
      for (Position step : steps) {
        check(!this.steps.contains(step), "Multiple steps on field [" + step + "] are not supported.");
        this.steps.add(step);
      }
    }
    
    public Tour(Board board, Position... steps) {
      this(board, asList(steps));
    }
  
    public boolean isFinished() {
      return steps.size() == board.getSize();
    }
    
    public Set<Position> getValidMoves() {
      Set<Position> result = new HashSet<>();
      for (Position move : board.getValidMoves(getLastStep())) {
        if (isValidMove(move)) {
          result.add(move);
        }
      }
      return result;
    }
  
    private boolean isValidMove(Position move) {
      return !steps.contains(move);
    }
  
    private Position getLastStep() {
      return steps.get(steps.size() - 1);
    }
  
    public Tour applyMove(Position move) {
      return new Tour(board, concat(steps, move));
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
      for (Position step : steps) {
        result.put(step, i);
        i++;
      }
      return result;
    }
    
    @Override
    public int hashCode() {
      return steps.hashCode();
    }
  
    @Override
    public boolean equals(Object obj) {
      return
        obj instanceof Tour &&
        steps.equals(((Tour) obj).steps);
    }
  
    @Override
    public String toString() {
      Map<Position, Integer> map = asMap();
      StringBuilder builder = new StringBuilder();
      for (int row = 0; row < board.getHeight(); row++) {
        for (int col = 0; col < board.getWidth(); col++) {
          Integer turn = map.get(board.getPosition(row, col));
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
}
