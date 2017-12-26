package cz.dusanrychnovsky.knightstour;

import cz.dusanrychnovsky.knightstour.Board.Position;
import org.junit.Test;

import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class BoardTest {

  private Board board = new Board(8, 8);

  // ==========================================================================
  // POSITION CONSTRUCTION & IDENTITY
  // ==========================================================================

  @Test(expected = AssertionError.class)
  public void getPosition_failsIfGivenRowIsLessThanZero() {
    board.getPosition(-1, 0);
  }
  
  @Test(expected = AssertionError.class)
  public void getPosition_failsIfGivenRowIsBeyondBoardHeight() {
    board.getPosition(8, 0);
  }

  @Test(expected = AssertionError.class)
  public void getPosition_smallerBoard_failsIfGivenRowIsBeyondBoardHeight() {
    new Board(4, 4).getPosition(4, 0);
  }
  
  @Test(expected = AssertionError.class)
  public void getPosition_failsIfGivenColumnIsLessThanZero() {
    board.getPosition(0, -1);
  }

  @Test(expected = AssertionError.class)
  public void getPosition_failsIfGivenColumnIsBeyondBoardWidth() {
    board.getPosition(0, 8);
  }

  @Test(expected = AssertionError.class)
  public void getPosition_smallerBoard_failsIfGivenColumnIsBeyondBoardWidth() {
    new Board(4, 4).getPosition(0, 4);
  }

  @Test
  public void canConstructProperPosition() {
    assertEquals("[0, 1]", board.getPosition(0, 1).toString());
  }
  
  @Test
  public void samePositionsAreEqual() {
    assertTrue(board.getPosition(0, 0).equals(board.getPosition(0, 0)));
  }
  
  @Test
  public void differentPositionsAreNotEqual() {
    assertFalse(board.getPosition(0, 0).equals(board.getPosition(0, 1)));
  }

  // ==========================================================================
  // BOARD SIZE
  // ==========================================================================

  @Test
  public void returnsBoardSize() {
    assertEquals(64, board.getSize());
  }

  // ==========================================================================
  // VALID MOVES - EMPTY BOARD
  // ==========================================================================
  
  @Test
  public void getValidMoves_thereAreTwoValidMovesFromTopLeftCorner() {
    Set<Position> moves = board.getValidMoves(board.getPosition(0, 0));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(board.getPosition(2, 1)));
    assertTrue(moves.contains(board.getPosition(1, 2)));
  }
  
  @Test
  public void getValidMoves_thereAreTwoValidMovesFromTopRightCorner() {
    Set<Position> moves = board.getValidMoves(board.getPosition(0, 7));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(board.getPosition(2, 6)));
    assertTrue(moves.contains(board.getPosition(1, 5)));
  }
  
  @Test
  public void getValidMoves_thereAreTwoValidMovesFromBottomLeftCorner() {
    Set<Position> moves = board.getValidMoves(board.getPosition(7, 0));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(board.getPosition(5, 1)));
    assertTrue(moves.contains(board.getPosition(6, 2)));
  }
  
  @Test
  public void getValidMoves_thereAreTwoValidMovesFromBottomRightCorner() {
    Set<Position> moves = board.getValidMoves(board.getPosition(7, 7));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(board.getPosition(5, 6)));
    assertTrue(moves.contains(board.getPosition(6, 5)));
  }
  
  @Test
  public void getValidMoves_thereAreFourValidMovesFromTopEdge() {
    Set<Position> moves = board.getValidMoves(board.getPosition(0, 2));
    assertEquals(4, moves.size());
    assertTrue(moves.contains(board.getPosition(1, 0)));
    assertTrue(moves.contains(board.getPosition(2, 1)));
    assertTrue(moves.contains(board.getPosition(2, 3)));
    assertTrue(moves.contains(board.getPosition(1, 4)));
  }
  
  @Test
  public void getValidMoves_thereAreEightValidMovesFromCenter() {
    Set<Position> moves = board.getValidMoves(board.getPosition(2, 2));
    assertEquals(8, moves.size());
    assertTrue(moves.contains(board.getPosition(0, 1)));
    assertTrue(moves.contains(board.getPosition(1, 0)));
    assertTrue(moves.contains(board.getPosition(3, 0)));
    assertTrue(moves.contains(board.getPosition(4, 1)));
    assertTrue(moves.contains(board.getPosition(4, 3)));
    assertTrue(moves.contains(board.getPosition(3, 4)));
    assertTrue(moves.contains(board.getPosition(1, 4)));
    assertTrue(moves.contains(board.getPosition(0, 3)));
  }

  @Test
  public void getValidMoves_reflectsBoardSize() {
    Board board = new Board(4, 4);
    Set<Position> moves = board.getValidMoves(board.getPosition(2 ,2));
    assertEquals(4, moves.size());
    assertTrue(moves.contains(board.getPosition(0, 1)));
    assertTrue(moves.contains(board.getPosition(1, 0)));
    assertTrue(moves.contains(board.getPosition(3, 0)));
    assertTrue(moves.contains(board.getPosition(0, 3)));
  }
}
