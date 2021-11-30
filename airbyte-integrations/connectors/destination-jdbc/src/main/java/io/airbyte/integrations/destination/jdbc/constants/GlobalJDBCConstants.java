package io.airbyte.integrations.destination.jdbc.constants;

public interface GlobalJDBCConstants {
  int MAX_BATCH_SIZE_BYTES = 1024 * 1024 * 1024 / 4; // 256 mib
  int MAX_PARTS_PER_FILE = 25000; // 25 GB per file, 25000 MB
}
