/*
 * Copyright (c) 2021 Airbyte, Inc., all rights reserved.
 */

package io.airbyte.commons.bytes;

import java.nio.charset.StandardCharsets;

public class ByteUtils {

  /**
   * Encodes this String into a sequence of bytes using the given charset.
   * @param s - string where charset length will be counted
   * @return length of bytes for charset
   */
  public static long getSizeInBytesForUTF8CharSet(String s) {
    return s.getBytes(StandardCharsets.UTF_8).length;
  }

}
