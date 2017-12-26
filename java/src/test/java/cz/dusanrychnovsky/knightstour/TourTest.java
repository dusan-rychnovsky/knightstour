package cz.dusanrychnovsky.knightstour;

import cz.dusanrychnovsky.knightstour.Board.Position;
import cz.dusanrychnovsky.knightstour.Main.Tour;
import java.util.Set;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class TourTest {

  private Board board = new Board(8, 8);

  // ==========================================================================
  // CONSTRUCTION
  // ==========================================================================
  
  @Test(expected = AssertionError.class)
  public void cannotCreateEmptyTour() {
    new Tour(board);
  }

  @Test(expected = AssertionError.class)
  public void cannotCreateTourWithMultipleStepsOnAField() {
    new Tour(
      board,
      board.getPosition(0, 0),
      board.getPosition(2, 1),
      board.getPosition(0, 0)
    );
  }
  @Test
  public void canCreateProperSituation() {
    new Tour(board, board.getPosition(0, 0), board.getPosition(2, 1));
  }
  
  // ==========================================================================
  // APPLY MOVE
  // ==========================================================================
  
  @Test(expected = AssertionError.class)
  public void cannotApplyAnAlreadyPresentMove() {
    new Tour(board, board.getPosition(0, 0), board.getPosition(2, 1))
      .applyMove(board.getPosition(0, 0));
  }
  
  @Test
  public void canApplyMove() {
    assertEquals(
      new Tour(board, board.getPosition(0, 0), board.getPosition(2, 1)),
      new Tour(board, board.getPosition(0, 0))
        .applyMove(board.getPosition(2, 1))
    );
  }
  
  // ==========================================================================
  // VALID MOVES - NON-EMPTY BOARD
  // ==========================================================================
  
  @Test
  public void cannotStepOnAnAlreadyVisitedField() {
    Set<Position> moves =
      new Tour(board, board.getPosition(1, 2), board.getPosition(0, 0))
        .getValidMoves();
    assertEquals(1, moves.size());
    assertTrue(moves.contains(board.getPosition(2, 1)));
  }
}
