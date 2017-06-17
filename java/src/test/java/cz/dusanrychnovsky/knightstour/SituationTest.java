package cz.dusanrychnovsky.knightstour;

import cz.dusanrychnovsky.knightstour.Main.Position;
import cz.dusanrychnovsky.knightstour.Main.Situation;
import org.junit.Test;

import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class SituationTest {
  
  // ==========================================================================
  // INSTANTIATION
  // ==========================================================================
  
  @Test(expected = AssertionError.class)
  public void cannotCreateEmptySituation() {
    new Situation();
  }

  @Test(expected = AssertionError.class)
  public void cannotCreateSituationWithMultipleStepsOnAField() {
    new Situation(
      new Position(0, 0),
      new Position(2, 1),
      new Position(0, 0)
    );
  }
  @Test
  public void canCreateProperSituation() {
    new Situation(new Position(0, 0), new Position(2, 1));
  }
  
  // ==========================================================================
  // APPLY MOVE
  // ==========================================================================
  
  @Test(expected = AssertionError.class)
  public void cannotApplyAnAlreadyPresentedMove() {
    new Situation(new Position(0, 0), new Position(2, 1))
      .applyMove(new Position(0, 0));
  }
  
  @Test
  public void canApplyMove() {
    assertEquals(
      new Situation(new Position(0, 0), new Position(2, 1)),
      new Situation(new Position(0, 0))
        .applyMove(new Position(2, 1))
    );
  }
  
  // ==========================================================================
  // VALID MOVES - NON-EMPTY BOARD
  // ==========================================================================
  
  @Test
  public void cannotStepOnAnAlreadyVisitedField() {
    Set<Position> moves =
      new Situation(new Position(1, 2), new Position(0, 0))
        .getValidMoves();
    assertEquals(1, moves.size());
    assertTrue(moves.contains(new Position(2, 1)));
  }
}
