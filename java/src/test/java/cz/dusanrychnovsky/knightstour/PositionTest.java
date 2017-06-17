package cz.dusanrychnovsky.knightstour;

import cz.dusanrychnovsky.knightstour.Main.Position;
import org.junit.Test;

import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class PositionTest {
  
  @Test(expected = AssertionError.class)
  public void failsIfGivenRowIsLessThanZero() {
    new Position(-1, 0);
  }
  
  @Test(expected = AssertionError.class)
  public void failsIfGivenRowIsMoreThanSeven() {
    new Position(8, 0);
  }
  
  @Test(expected = AssertionError.class)
  public void failsIfGivenColumnIsLessThanZero() {
    new Position(0, -1);
  }
  
  @Test(expected = AssertionError.class)
  public void failsIfGivenColumnIsMoreThanSeven() {
    new Position(0, 8);
  }
  
  @Test
  public void canConstructProperPosition() {
    assertEquals("[0, 1]", new Position(0, 1).toString());
  }
  
  @Test
  public void samePositionsAreEqual() {
    assertTrue(new Position(0, 0).equals(new Position(0, 0)));
  }
  
  @Test
  public void differentPositionsAreNotEqual() {
    assertFalse(new Position(0, 0).equals(new Position(0, 1)));
  }
  
  // ==========================================================================
  // VALID MOVES - EMPTY BOARD
  // ==========================================================================
  
  @Test
  public void thereAreTwoValidMovesFromTopLeftCorner() {
    Set<Position> moves = Position.getValidMoves(new Position(0, 0));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(new Position(2, 1)));
    assertTrue(moves.contains(new Position(1, 2)));
  }
  
  @Test
  public void thereAreTwoValidMovesFromTopRightCorner() {
    Set<Position> moves = Position.getValidMoves(new Position(0, 7));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(new Position(2, 6)));
    assertTrue(moves.contains(new Position(1, 5)));
  }
  
  @Test
  public void thereAreTwoValidMovesFromBottomLeftCorner() {
    Set<Position> moves = Position.getValidMoves(new Position(7, 0));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(new Position(5, 1)));
    assertTrue(moves.contains(new Position(6, 2)));
  }
  
  @Test
  public void thereAreTwoValidMovesFromBottomRightCorner() {
    Set<Position> moves = Position.getValidMoves(new Position(7, 7));
    assertEquals(2, moves.size());
    assertTrue(moves.contains(new Position(5, 6)));
    assertTrue(moves.contains(new Position(6, 5)));
  }
  
  @Test
  public void thereAreFourValidMovesFromTopEdge() {
    Set<Position> moves = Position.getValidMoves(new Position(0, 2));
    assertEquals(4, moves.size());
    assertTrue(moves.contains(new Position(1, 0)));
    assertTrue(moves.contains(new Position(2, 1)));
    assertTrue(moves.contains(new Position(2, 3)));
    assertTrue(moves.contains(new Position(1, 4)));
  }
  
  @Test
  public void thereAreEightValidMovesFromCenter() {
    Set<Position> moves = Position.getValidMoves(new Position(2, 2));
    assertEquals(8, moves.size());
    assertTrue(moves.contains(new Position(0, 1)));
    assertTrue(moves.contains(new Position(1, 0)));
    assertTrue(moves.contains(new Position(3, 0)));
    assertTrue(moves.contains(new Position(4, 1)));
    assertTrue(moves.contains(new Position(4, 3)));
    assertTrue(moves.contains(new Position(3, 4)));
    assertTrue(moves.contains(new Position(1, 4)));
    assertTrue(moves.contains(new Position(0, 3)));
  }
}
