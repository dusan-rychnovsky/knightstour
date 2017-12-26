package cz.dusanrychnovsky.knightstour;

public class Util {

  public static void check(boolean cond, String message) {
    if (!cond) {
      throw new AssertionError(message);
    }
  }
}
