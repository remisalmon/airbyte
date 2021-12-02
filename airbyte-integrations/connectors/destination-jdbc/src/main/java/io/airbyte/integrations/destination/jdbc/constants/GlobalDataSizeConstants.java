package io.airbyte.integrations.destination.jdbc.constants;

import io.aesy.datasize.ByteUnit.IEC;
import io.aesy.datasize.DataSize;

public interface GlobalDataSizeConstants {
  // 256 MB to BYTES as comparison will be done in BYTES
  int MAX_BATCH_SIZE_BYTES = DataSize.of(256L, IEC.MEBIBYTE).toUnit(IEC.BYTE).getValue().intValue();
  long MAX_BYTE_PARTS_PER_FILE = DataSize.of(15L, IEC.GIBIBYTE).toUnit(IEC.BYTE).getValue().longValue();
}
