// ORM class for table 'cp_outbox'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Tue Nov 24 17:56:00 EST 2015
// For connector: org.apache.sqoop.manager.GenericJdbcManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class cp_outbox extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private Long email_pkg_id;
  public Long get_email_pkg_id() {
    return email_pkg_id;
  }
  public void set_email_pkg_id(Long email_pkg_id) {
    this.email_pkg_id = email_pkg_id;
  }
  public cp_outbox with_email_pkg_id(Long email_pkg_id) {
    this.email_pkg_id = email_pkg_id;
    return this;
  }
  private String loy_id;
  public String get_loy_id() {
    return loy_id;
  }
  public void set_loy_id(String loy_id) {
    this.loy_id = loy_id;
  }
  public cp_outbox with_loy_id(String loy_id) {
    this.loy_id = loy_id;
    return this;
  }
  private String bu;
  public String get_bu() {
    return bu;
  }
  public void set_bu(String bu) {
    this.bu = bu;
  }
  public cp_outbox with_bu(String bu) {
    this.bu = bu;
    return this;
  }
  private String sub_bu;
  public String get_sub_bu() {
    return sub_bu;
  }
  public void set_sub_bu(String sub_bu) {
    this.sub_bu = sub_bu;
  }
  public cp_outbox with_sub_bu(String sub_bu) {
    this.sub_bu = sub_bu;
    return this;
  }
  private String md_tag;
  public String get_md_tag() {
    return md_tag;
  }
  public void set_md_tag(String md_tag) {
    this.md_tag = md_tag;
  }
  public cp_outbox with_md_tag(String md_tag) {
    this.md_tag = md_tag;
    return this;
  }
  private String occasion_name;
  public String get_occasion_name() {
    return occasion_name;
  }
  public void set_occasion_name(String occasion_name) {
    this.occasion_name = occasion_name;
  }
  public cp_outbox with_occasion_name(String occasion_name) {
    this.occasion_name = occasion_name;
    return this;
  }
  private java.sql.Timestamp added_datetime;
  public java.sql.Timestamp get_added_datetime() {
    return added_datetime;
  }
  public void set_added_datetime(java.sql.Timestamp added_datetime) {
    this.added_datetime = added_datetime;
  }
  public cp_outbox with_added_datetime(java.sql.Timestamp added_datetime) {
    this.added_datetime = added_datetime;
    return this;
  }
  private java.sql.Date send_date;
  public java.sql.Date get_send_date() {
    return send_date;
  }
  public void set_send_date(java.sql.Date send_date) {
    this.send_date = send_date;
  }
  public cp_outbox with_send_date(java.sql.Date send_date) {
    this.send_date = send_date;
    return this;
  }
  private Integer status;
  public Integer get_status() {
    return status;
  }
  public void set_status(Integer status) {
    this.status = status;
  }
  public cp_outbox with_status(Integer status) {
    this.status = status;
    return this;
  }
  private java.sql.Timestamp sent_datetime;
  public java.sql.Timestamp get_sent_datetime() {
    return sent_datetime;
  }
  public void set_sent_datetime(java.sql.Timestamp sent_datetime) {
    this.sent_datetime = sent_datetime;
  }
  public cp_outbox with_sent_datetime(java.sql.Timestamp sent_datetime) {
    this.sent_datetime = sent_datetime;
    return this;
  }
  private String cust_event_name;
  public String get_cust_event_name() {
    return cust_event_name;
  }
  public void set_cust_event_name(String cust_event_name) {
    this.cust_event_name = cust_event_name;
  }
  public cp_outbox with_cust_event_name(String cust_event_name) {
    this.cust_event_name = cust_event_name;
    return this;
  }
  private String customer_id;
  public String get_customer_id() {
    return customer_id;
  }
  public void set_customer_id(String customer_id) {
    this.customer_id = customer_id;
  }
  public cp_outbox with_customer_id(String customer_id) {
    this.customer_id = customer_id;
    return this;
  }
  private String sears_opt_in;
  public String get_sears_opt_in() {
    return sears_opt_in;
  }
  public void set_sears_opt_in(String sears_opt_in) {
    this.sears_opt_in = sears_opt_in;
  }
  public cp_outbox with_sears_opt_in(String sears_opt_in) {
    this.sears_opt_in = sears_opt_in;
    return this;
  }
  private String kmart_opt_in;
  public String get_kmart_opt_in() {
    return kmart_opt_in;
  }
  public void set_kmart_opt_in(String kmart_opt_in) {
    this.kmart_opt_in = kmart_opt_in;
  }
  public cp_outbox with_kmart_opt_in(String kmart_opt_in) {
    this.kmart_opt_in = kmart_opt_in;
    return this;
  }
  private String syw_opt_in;
  public String get_syw_opt_in() {
    return syw_opt_in;
  }
  public void set_syw_opt_in(String syw_opt_in) {
    this.syw_opt_in = syw_opt_in;
  }
  public cp_outbox with_syw_opt_in(String syw_opt_in) {
    this.syw_opt_in = syw_opt_in;
    return this;
  }
  private java.sql.Timestamp last_updated_timestamp;
  public java.sql.Timestamp get_last_updated_timestamp() {
    return last_updated_timestamp;
  }
  public void set_last_updated_timestamp(java.sql.Timestamp last_updated_timestamp) {
    this.last_updated_timestamp = last_updated_timestamp;
  }
  public cp_outbox with_last_updated_timestamp(java.sql.Timestamp last_updated_timestamp) {
    this.last_updated_timestamp = last_updated_timestamp;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof cp_outbox)) {
      return false;
    }
    cp_outbox that = (cp_outbox) o;
    boolean equal = true;
    equal = equal && (this.email_pkg_id == null ? that.email_pkg_id == null : this.email_pkg_id.equals(that.email_pkg_id));
    equal = equal && (this.loy_id == null ? that.loy_id == null : this.loy_id.equals(that.loy_id));
    equal = equal && (this.bu == null ? that.bu == null : this.bu.equals(that.bu));
    equal = equal && (this.sub_bu == null ? that.sub_bu == null : this.sub_bu.equals(that.sub_bu));
    equal = equal && (this.md_tag == null ? that.md_tag == null : this.md_tag.equals(that.md_tag));
    equal = equal && (this.occasion_name == null ? that.occasion_name == null : this.occasion_name.equals(that.occasion_name));
    equal = equal && (this.added_datetime == null ? that.added_datetime == null : this.added_datetime.equals(that.added_datetime));
    equal = equal && (this.send_date == null ? that.send_date == null : this.send_date.equals(that.send_date));
    equal = equal && (this.status == null ? that.status == null : this.status.equals(that.status));
    equal = equal && (this.sent_datetime == null ? that.sent_datetime == null : this.sent_datetime.equals(that.sent_datetime));
    equal = equal && (this.cust_event_name == null ? that.cust_event_name == null : this.cust_event_name.equals(that.cust_event_name));
    equal = equal && (this.customer_id == null ? that.customer_id == null : this.customer_id.equals(that.customer_id));
    equal = equal && (this.sears_opt_in == null ? that.sears_opt_in == null : this.sears_opt_in.equals(that.sears_opt_in));
    equal = equal && (this.kmart_opt_in == null ? that.kmart_opt_in == null : this.kmart_opt_in.equals(that.kmart_opt_in));
    equal = equal && (this.syw_opt_in == null ? that.syw_opt_in == null : this.syw_opt_in.equals(that.syw_opt_in));
    equal = equal && (this.last_updated_timestamp == null ? that.last_updated_timestamp == null : this.last_updated_timestamp.equals(that.last_updated_timestamp));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof cp_outbox)) {
      return false;
    }
    cp_outbox that = (cp_outbox) o;
    boolean equal = true;
    equal = equal && (this.email_pkg_id == null ? that.email_pkg_id == null : this.email_pkg_id.equals(that.email_pkg_id));
    equal = equal && (this.loy_id == null ? that.loy_id == null : this.loy_id.equals(that.loy_id));
    equal = equal && (this.bu == null ? that.bu == null : this.bu.equals(that.bu));
    equal = equal && (this.sub_bu == null ? that.sub_bu == null : this.sub_bu.equals(that.sub_bu));
    equal = equal && (this.md_tag == null ? that.md_tag == null : this.md_tag.equals(that.md_tag));
    equal = equal && (this.occasion_name == null ? that.occasion_name == null : this.occasion_name.equals(that.occasion_name));
    equal = equal && (this.added_datetime == null ? that.added_datetime == null : this.added_datetime.equals(that.added_datetime));
    equal = equal && (this.send_date == null ? that.send_date == null : this.send_date.equals(that.send_date));
    equal = equal && (this.status == null ? that.status == null : this.status.equals(that.status));
    equal = equal && (this.sent_datetime == null ? that.sent_datetime == null : this.sent_datetime.equals(that.sent_datetime));
    equal = equal && (this.cust_event_name == null ? that.cust_event_name == null : this.cust_event_name.equals(that.cust_event_name));
    equal = equal && (this.customer_id == null ? that.customer_id == null : this.customer_id.equals(that.customer_id));
    equal = equal && (this.sears_opt_in == null ? that.sears_opt_in == null : this.sears_opt_in.equals(that.sears_opt_in));
    equal = equal && (this.kmart_opt_in == null ? that.kmart_opt_in == null : this.kmart_opt_in.equals(that.kmart_opt_in));
    equal = equal && (this.syw_opt_in == null ? that.syw_opt_in == null : this.syw_opt_in.equals(that.syw_opt_in));
    equal = equal && (this.last_updated_timestamp == null ? that.last_updated_timestamp == null : this.last_updated_timestamp.equals(that.last_updated_timestamp));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.email_pkg_id = JdbcWritableBridge.readLong(1, __dbResults);
    this.loy_id = JdbcWritableBridge.readString(2, __dbResults);
    this.bu = JdbcWritableBridge.readString(3, __dbResults);
    this.sub_bu = JdbcWritableBridge.readString(4, __dbResults);
    this.md_tag = JdbcWritableBridge.readString(5, __dbResults);
    this.occasion_name = JdbcWritableBridge.readString(6, __dbResults);
    this.added_datetime = JdbcWritableBridge.readTimestamp(7, __dbResults);
    this.send_date = JdbcWritableBridge.readDate(8, __dbResults);
    this.status = JdbcWritableBridge.readInteger(9, __dbResults);
    this.sent_datetime = JdbcWritableBridge.readTimestamp(10, __dbResults);
    this.cust_event_name = JdbcWritableBridge.readString(11, __dbResults);
    this.customer_id = JdbcWritableBridge.readString(12, __dbResults);
    this.sears_opt_in = JdbcWritableBridge.readString(13, __dbResults);
    this.kmart_opt_in = JdbcWritableBridge.readString(14, __dbResults);
    this.syw_opt_in = JdbcWritableBridge.readString(15, __dbResults);
    this.last_updated_timestamp = JdbcWritableBridge.readTimestamp(16, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.email_pkg_id = JdbcWritableBridge.readLong(1, __dbResults);
    this.loy_id = JdbcWritableBridge.readString(2, __dbResults);
    this.bu = JdbcWritableBridge.readString(3, __dbResults);
    this.sub_bu = JdbcWritableBridge.readString(4, __dbResults);
    this.md_tag = JdbcWritableBridge.readString(5, __dbResults);
    this.occasion_name = JdbcWritableBridge.readString(6, __dbResults);
    this.added_datetime = JdbcWritableBridge.readTimestamp(7, __dbResults);
    this.send_date = JdbcWritableBridge.readDate(8, __dbResults);
    this.status = JdbcWritableBridge.readInteger(9, __dbResults);
    this.sent_datetime = JdbcWritableBridge.readTimestamp(10, __dbResults);
    this.cust_event_name = JdbcWritableBridge.readString(11, __dbResults);
    this.customer_id = JdbcWritableBridge.readString(12, __dbResults);
    this.sears_opt_in = JdbcWritableBridge.readString(13, __dbResults);
    this.kmart_opt_in = JdbcWritableBridge.readString(14, __dbResults);
    this.syw_opt_in = JdbcWritableBridge.readString(15, __dbResults);
    this.last_updated_timestamp = JdbcWritableBridge.readTimestamp(16, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(email_pkg_id, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeString(loy_id, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(bu, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(sub_bu, 4 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(md_tag, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(occasion_name, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(added_datetime, 7 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeDate(send_date, 8 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeInteger(status, 9 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeTimestamp(sent_datetime, 10 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(cust_event_name, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(customer_id, 12 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(sears_opt_in, 13 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(kmart_opt_in, 14 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(syw_opt_in, 15 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(last_updated_timestamp, 16 + __off, 93, __dbStmt);
    return 16;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(email_pkg_id, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeString(loy_id, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(bu, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(sub_bu, 4 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(md_tag, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(occasion_name, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(added_datetime, 7 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeDate(send_date, 8 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeInteger(status, 9 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeTimestamp(sent_datetime, 10 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(cust_event_name, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(customer_id, 12 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(sears_opt_in, 13 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(kmart_opt_in, 14 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(syw_opt_in, 15 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(last_updated_timestamp, 16 + __off, 93, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.email_pkg_id = null;
    } else {
    this.email_pkg_id = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.loy_id = null;
    } else {
    this.loy_id = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.bu = null;
    } else {
    this.bu = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.sub_bu = null;
    } else {
    this.sub_bu = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.md_tag = null;
    } else {
    this.md_tag = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.occasion_name = null;
    } else {
    this.occasion_name = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.added_datetime = null;
    } else {
    this.added_datetime = new Timestamp(__dataIn.readLong());
    this.added_datetime.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.send_date = null;
    } else {
    this.send_date = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.status = null;
    } else {
    this.status = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.sent_datetime = null;
    } else {
    this.sent_datetime = new Timestamp(__dataIn.readLong());
    this.sent_datetime.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.cust_event_name = null;
    } else {
    this.cust_event_name = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.customer_id = null;
    } else {
    this.customer_id = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.sears_opt_in = null;
    } else {
    this.sears_opt_in = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.kmart_opt_in = null;
    } else {
    this.kmart_opt_in = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.syw_opt_in = null;
    } else {
    this.syw_opt_in = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.last_updated_timestamp = null;
    } else {
    this.last_updated_timestamp = new Timestamp(__dataIn.readLong());
    this.last_updated_timestamp.setNanos(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.email_pkg_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.email_pkg_id);
    }
    if (null == this.loy_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, loy_id);
    }
    if (null == this.bu) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, bu);
    }
    if (null == this.sub_bu) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, sub_bu);
    }
    if (null == this.md_tag) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, md_tag);
    }
    if (null == this.occasion_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, occasion_name);
    }
    if (null == this.added_datetime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.added_datetime.getTime());
    __dataOut.writeInt(this.added_datetime.getNanos());
    }
    if (null == this.send_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.send_date.getTime());
    }
    if (null == this.status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.status);
    }
    if (null == this.sent_datetime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.sent_datetime.getTime());
    __dataOut.writeInt(this.sent_datetime.getNanos());
    }
    if (null == this.cust_event_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, cust_event_name);
    }
    if (null == this.customer_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_id);
    }
    if (null == this.sears_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, sears_opt_in);
    }
    if (null == this.kmart_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, kmart_opt_in);
    }
    if (null == this.syw_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, syw_opt_in);
    }
    if (null == this.last_updated_timestamp) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.last_updated_timestamp.getTime());
    __dataOut.writeInt(this.last_updated_timestamp.getNanos());
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.email_pkg_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.email_pkg_id);
    }
    if (null == this.loy_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, loy_id);
    }
    if (null == this.bu) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, bu);
    }
    if (null == this.sub_bu) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, sub_bu);
    }
    if (null == this.md_tag) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, md_tag);
    }
    if (null == this.occasion_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, occasion_name);
    }
    if (null == this.added_datetime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.added_datetime.getTime());
    __dataOut.writeInt(this.added_datetime.getNanos());
    }
    if (null == this.send_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.send_date.getTime());
    }
    if (null == this.status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.status);
    }
    if (null == this.sent_datetime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.sent_datetime.getTime());
    __dataOut.writeInt(this.sent_datetime.getNanos());
    }
    if (null == this.cust_event_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, cust_event_name);
    }
    if (null == this.customer_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, customer_id);
    }
    if (null == this.sears_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, sears_opt_in);
    }
    if (null == this.kmart_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, kmart_opt_in);
    }
    if (null == this.syw_opt_in) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, syw_opt_in);
    }
    if (null == this.last_updated_timestamp) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.last_updated_timestamp.getTime());
    __dataOut.writeInt(this.last_updated_timestamp.getNanos());
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(email_pkg_id==null?"null":"" + email_pkg_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(loy_id==null?"null":loy_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(bu==null?"null":bu, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sub_bu==null?"null":sub_bu, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(md_tag==null?"null":md_tag, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(occasion_name==null?"null":occasion_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(added_datetime==null?"null":"" + added_datetime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(send_date==null?"null":"" + send_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(status==null?"null":"" + status, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sent_datetime==null?"null":"" + sent_datetime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cust_event_name==null?"null":cust_event_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_id==null?"null":customer_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sears_opt_in==null?"null":sears_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(kmart_opt_in==null?"null":kmart_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(syw_opt_in==null?"null":syw_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(last_updated_timestamp==null?"null":"" + last_updated_timestamp, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(email_pkg_id==null?"null":"" + email_pkg_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(loy_id==null?"null":loy_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(bu==null?"null":bu, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sub_bu==null?"null":sub_bu, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(md_tag==null?"null":md_tag, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(occasion_name==null?"null":occasion_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(added_datetime==null?"null":"" + added_datetime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(send_date==null?"null":"" + send_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(status==null?"null":"" + status, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sent_datetime==null?"null":"" + sent_datetime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cust_event_name==null?"null":cust_event_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(customer_id==null?"null":customer_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sears_opt_in==null?"null":sears_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(kmart_opt_in==null?"null":kmart_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(syw_opt_in==null?"null":syw_opt_in, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(last_updated_timestamp==null?"null":"" + last_updated_timestamp, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.email_pkg_id = null; } else {
      this.email_pkg_id = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.loy_id = null; } else {
      this.loy_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.bu = null; } else {
      this.bu = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.sub_bu = null; } else {
      this.sub_bu = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.md_tag = null; } else {
      this.md_tag = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.occasion_name = null; } else {
      this.occasion_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.added_datetime = null; } else {
      this.added_datetime = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.send_date = null; } else {
      this.send_date = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.status = null; } else {
      this.status = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.sent_datetime = null; } else {
      this.sent_datetime = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.cust_event_name = null; } else {
      this.cust_event_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_id = null; } else {
      this.customer_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.sears_opt_in = null; } else {
      this.sears_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.kmart_opt_in = null; } else {
      this.kmart_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.syw_opt_in = null; } else {
      this.syw_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.last_updated_timestamp = null; } else {
      this.last_updated_timestamp = java.sql.Timestamp.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.email_pkg_id = null; } else {
      this.email_pkg_id = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.loy_id = null; } else {
      this.loy_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.bu = null; } else {
      this.bu = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.sub_bu = null; } else {
      this.sub_bu = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.md_tag = null; } else {
      this.md_tag = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.occasion_name = null; } else {
      this.occasion_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.added_datetime = null; } else {
      this.added_datetime = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.send_date = null; } else {
      this.send_date = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.status = null; } else {
      this.status = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.sent_datetime = null; } else {
      this.sent_datetime = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.cust_event_name = null; } else {
      this.cust_event_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.customer_id = null; } else {
      this.customer_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.sears_opt_in = null; } else {
      this.sears_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.kmart_opt_in = null; } else {
      this.kmart_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.syw_opt_in = null; } else {
      this.syw_opt_in = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.last_updated_timestamp = null; } else {
      this.last_updated_timestamp = java.sql.Timestamp.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    cp_outbox o = (cp_outbox) super.clone();
    o.added_datetime = (o.added_datetime != null) ? (java.sql.Timestamp) o.added_datetime.clone() : null;
    o.send_date = (o.send_date != null) ? (java.sql.Date) o.send_date.clone() : null;
    o.sent_datetime = (o.sent_datetime != null) ? (java.sql.Timestamp) o.sent_datetime.clone() : null;
    o.last_updated_timestamp = (o.last_updated_timestamp != null) ? (java.sql.Timestamp) o.last_updated_timestamp.clone() : null;
    return o;
  }

  public void clone0(cp_outbox o) throws CloneNotSupportedException {
    o.added_datetime = (o.added_datetime != null) ? (java.sql.Timestamp) o.added_datetime.clone() : null;
    o.send_date = (o.send_date != null) ? (java.sql.Date) o.send_date.clone() : null;
    o.sent_datetime = (o.sent_datetime != null) ? (java.sql.Timestamp) o.sent_datetime.clone() : null;
    o.last_updated_timestamp = (o.last_updated_timestamp != null) ? (java.sql.Timestamp) o.last_updated_timestamp.clone() : null;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("email_pkg_id", this.email_pkg_id);
    __sqoop$field_map.put("loy_id", this.loy_id);
    __sqoop$field_map.put("bu", this.bu);
    __sqoop$field_map.put("sub_bu", this.sub_bu);
    __sqoop$field_map.put("md_tag", this.md_tag);
    __sqoop$field_map.put("occasion_name", this.occasion_name);
    __sqoop$field_map.put("added_datetime", this.added_datetime);
    __sqoop$field_map.put("send_date", this.send_date);
    __sqoop$field_map.put("status", this.status);
    __sqoop$field_map.put("sent_datetime", this.sent_datetime);
    __sqoop$field_map.put("cust_event_name", this.cust_event_name);
    __sqoop$field_map.put("customer_id", this.customer_id);
    __sqoop$field_map.put("sears_opt_in", this.sears_opt_in);
    __sqoop$field_map.put("kmart_opt_in", this.kmart_opt_in);
    __sqoop$field_map.put("syw_opt_in", this.syw_opt_in);
    __sqoop$field_map.put("last_updated_timestamp", this.last_updated_timestamp);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("email_pkg_id", this.email_pkg_id);
    __sqoop$field_map.put("loy_id", this.loy_id);
    __sqoop$field_map.put("bu", this.bu);
    __sqoop$field_map.put("sub_bu", this.sub_bu);
    __sqoop$field_map.put("md_tag", this.md_tag);
    __sqoop$field_map.put("occasion_name", this.occasion_name);
    __sqoop$field_map.put("added_datetime", this.added_datetime);
    __sqoop$field_map.put("send_date", this.send_date);
    __sqoop$field_map.put("status", this.status);
    __sqoop$field_map.put("sent_datetime", this.sent_datetime);
    __sqoop$field_map.put("cust_event_name", this.cust_event_name);
    __sqoop$field_map.put("customer_id", this.customer_id);
    __sqoop$field_map.put("sears_opt_in", this.sears_opt_in);
    __sqoop$field_map.put("kmart_opt_in", this.kmart_opt_in);
    __sqoop$field_map.put("syw_opt_in", this.syw_opt_in);
    __sqoop$field_map.put("last_updated_timestamp", this.last_updated_timestamp);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("email_pkg_id".equals(__fieldName)) {
      this.email_pkg_id = (Long) __fieldVal;
    }
    else    if ("loy_id".equals(__fieldName)) {
      this.loy_id = (String) __fieldVal;
    }
    else    if ("bu".equals(__fieldName)) {
      this.bu = (String) __fieldVal;
    }
    else    if ("sub_bu".equals(__fieldName)) {
      this.sub_bu = (String) __fieldVal;
    }
    else    if ("md_tag".equals(__fieldName)) {
      this.md_tag = (String) __fieldVal;
    }
    else    if ("occasion_name".equals(__fieldName)) {
      this.occasion_name = (String) __fieldVal;
    }
    else    if ("added_datetime".equals(__fieldName)) {
      this.added_datetime = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("send_date".equals(__fieldName)) {
      this.send_date = (java.sql.Date) __fieldVal;
    }
    else    if ("status".equals(__fieldName)) {
      this.status = (Integer) __fieldVal;
    }
    else    if ("sent_datetime".equals(__fieldName)) {
      this.sent_datetime = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("cust_event_name".equals(__fieldName)) {
      this.cust_event_name = (String) __fieldVal;
    }
    else    if ("customer_id".equals(__fieldName)) {
      this.customer_id = (String) __fieldVal;
    }
    else    if ("sears_opt_in".equals(__fieldName)) {
      this.sears_opt_in = (String) __fieldVal;
    }
    else    if ("kmart_opt_in".equals(__fieldName)) {
      this.kmart_opt_in = (String) __fieldVal;
    }
    else    if ("syw_opt_in".equals(__fieldName)) {
      this.syw_opt_in = (String) __fieldVal;
    }
    else    if ("last_updated_timestamp".equals(__fieldName)) {
      this.last_updated_timestamp = (java.sql.Timestamp) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
  public boolean setField0(String __fieldName, Object __fieldVal) {
    if ("email_pkg_id".equals(__fieldName)) {
      this.email_pkg_id = (Long) __fieldVal;
      return true;
    }
    else    if ("loy_id".equals(__fieldName)) {
      this.loy_id = (String) __fieldVal;
      return true;
    }
    else    if ("bu".equals(__fieldName)) {
      this.bu = (String) __fieldVal;
      return true;
    }
    else    if ("sub_bu".equals(__fieldName)) {
      this.sub_bu = (String) __fieldVal;
      return true;
    }
    else    if ("md_tag".equals(__fieldName)) {
      this.md_tag = (String) __fieldVal;
      return true;
    }
    else    if ("occasion_name".equals(__fieldName)) {
      this.occasion_name = (String) __fieldVal;
      return true;
    }
    else    if ("added_datetime".equals(__fieldName)) {
      this.added_datetime = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else    if ("send_date".equals(__fieldName)) {
      this.send_date = (java.sql.Date) __fieldVal;
      return true;
    }
    else    if ("status".equals(__fieldName)) {
      this.status = (Integer) __fieldVal;
      return true;
    }
    else    if ("sent_datetime".equals(__fieldName)) {
      this.sent_datetime = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else    if ("cust_event_name".equals(__fieldName)) {
      this.cust_event_name = (String) __fieldVal;
      return true;
    }
    else    if ("customer_id".equals(__fieldName)) {
      this.customer_id = (String) __fieldVal;
      return true;
    }
    else    if ("sears_opt_in".equals(__fieldName)) {
      this.sears_opt_in = (String) __fieldVal;
      return true;
    }
    else    if ("kmart_opt_in".equals(__fieldName)) {
      this.kmart_opt_in = (String) __fieldVal;
      return true;
    }
    else    if ("syw_opt_in".equals(__fieldName)) {
      this.syw_opt_in = (String) __fieldVal;
      return true;
    }
    else    if ("last_updated_timestamp".equals(__fieldName)) {
      this.last_updated_timestamp = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else {
      return false;    }
  }
}
