
CREATE KEYSPACE cdsdb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'}  AND durable_writes = true;

CREATE TABLE cdsdb.job_status (
    job_name text PRIMARY KEY,
    expiration_time timestamp,
    last_processed_time timestamp
) WITH bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE cdsdb.profile (
    id uuid PRIMARY KEY,
    summary text
) WITH bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE cdsdb.clustered_data (
    hash_prefix int,
    cds_id uuid,
    profile_id uuid,
    confidence_level text,
    end timestamp,
    is_updated boolean,
    notif_stats map<text, text>,
    profile text,
    source_id_map map<text, text>,
    start timestamp,
    PRIMARY KEY ((hash_prefix, cds_id), profile_id)
) WITH CLUSTERING ORDER BY (profile_id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX cds_id_index_tmp1 ON cdsdb.clustered_data (cds_id);
CREATE INDEX end_index ON cdsdb.clustered_data (end);
CREATE INDEX is_updated_index ON cdsdb.clustered_data (is_updated);

CREATE TABLE cdsdb.unprocessed_customer_data (
    updated_on_day timestamp,
    updated_on timestamp,
    id text,
    source text,
    created_on timestamp,
    data text,
    domain text,
    is_processed boolean,
    PRIMARY KEY (updated_on_day, updated_on, id, source)
) WITH CLUSTERING ORDER BY (updated_on ASC, id ASC, source ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX id_index ON cdsdb.unprocessed_customer_data (id);
CREATE INDEX is_processed_index ON cdsdb.unprocessed_customer_data (is_processed);

CREATE TABLE cdsdb.user_info (
    user_source text,
    user_value text,
    cds_id uuid,
    PRIMARY KEY (user_source, user_value)
) WITH CLUSTERING ORDER BY (user_value ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX cds_id_index ON cdsdb.user_info (cds_id);

CREATE TABLE cdsdb.clustered_data_copy (
    start_day timestamp,
    start timeuuid,
    cds_id uuid,
    confidence_level text,
    end timestamp,
    notif_stats map<text, text>,
    profile text,
    profile_id uuid,
    source_id_map map<text, text>,
    PRIMARY KEY (start_day, start, cds_id)
) WITH CLUSTERING ORDER BY (start ASC, cds_id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX clustered_data_copy_end_index ON cdsdb.clustered_data_copy (end);

CREATE TABLE cdsdb.phone_contact_data (
    updated_on_day timestamp,
    updated_on timestamp,
    cds_id uuid,
    contact_data_json text,
    PRIMARY KEY (updated_on_day, updated_on, cds_id)
) WITH CLUSTERING ORDER BY (updated_on ASC, cds_id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX phone_contact_data_cds_id_index ON cdsdb.phone_contact_data (cds_id);

CREATE KEYSPACE cds_test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'}  AND durable_writes = true;

CREATE TABLE cds_test.job_status (
    job_name text PRIMARY KEY,
    last_processed_time timestamp
) WITH bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE cds_test.profile (
    id uuid PRIMARY KEY,
    summary text
) WITH bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE cds_test.clustered_data (
    hash_prefix int,
    cds_id uuid,
    profile_id uuid,
    confidence_level text,
    end timestamp,
    source_id_map map<text, text>,
    start timestamp,
    PRIMARY KEY ((hash_prefix, cds_id), profile_id)
) WITH CLUSTERING ORDER BY (profile_id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX end_index ON cds_test.clustered_data (end);

CREATE TABLE cds_test.unprocessed_customer_data (
    updated_on_day timestamp,
    updated_on timestamp,
    id text,
    source text,
    created_on timestamp,
    data text,
    PRIMARY KEY (updated_on_day, updated_on, id, source)
) WITH CLUSTERING ORDER BY (updated_on ASC, id ASC, source ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX id_index ON cds_test.unprocessed_customer_data (id);

CREATE TABLE cds_test.clustered_data_clone (
    start_day timestamp,
    start timestamp,
    cds_id uuid,
    confidence_level text,
    end timestamp,
    profile_id uuid,
    source_id_map map<text, text>,
    PRIMARY KEY (start_day, start)
) WITH CLUSTERING ORDER BY (start ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX clustered_data_clone_end_index ON cds_test.clustered_data_clone (end);

CREATE TABLE cds_test.user_info (
    user_source text,
    user_value text,
    cds_id uuid,
    PRIMARY KEY (user_source, user_value)
) WITH CLUSTERING ORDER BY (user_value ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX cds_id_index ON cds_test.user_info (cds_id);

CREATE TABLE cds_test.customer_raw_data (
    id_hash int,
    id uuid,
    cds_id uuid,
    created_on timestamp,
    data_source text,
    last_modified_on timestamp,
    processed boolean,
    session_id text,
    source_id text,
    PRIMARY KEY (id_hash, id)
) WITH CLUSTERING ORDER BY (id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX processed_index ON cds_test.customer_raw_data (processed);

CREATE KEYSPACE mp_data WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '2'}  AND durable_writes = true;

CREATE TABLE mp_data.preapproved_upload (
    upload_id text PRIMARY KEY,
    bank_id text,
    end_date timestamp,
    start_date timestamp
) WITH bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE mp_data.user_mobile_sms (
    device_id text,
    sms_timestamp timestamp,
    sender_id text,
    json_data text,
    login_id text,
    message_body text,
    modified_on timestamp,
    phone_number text,
    PRIMARY KEY (device_id, sms_timestamp, sender_id)
) WITH CLUSTERING ORDER BY (sms_timestamp ASC, sender_id ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';

CREATE TABLE mp_data.preapproved_bankdata (
    bank_id text,
    hashkey int,
    product_type_id text,
    lookup_key text,
    upload_id text,
    clob text,
    PRIMARY KEY ((bank_id, hashkey), product_type_id, lookup_key, upload_id, clob)
) WITH CLUSTERING ORDER BY (product_type_id ASC, lookup_key ASC, upload_id ASC, clob ASC)
    AND bloom_filter_fp_chance = 0.01
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
CREATE INDEX upload_idx ON mp_data.preapproved_bankdata (upload_id);

