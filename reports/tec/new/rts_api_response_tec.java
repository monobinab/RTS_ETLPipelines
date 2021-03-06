// ORM class for table 'rts_api_response_tec'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Mon Apr 04 18:14:32 EDT 2016
// For connector: com.cloudera.connector.teradata.TeradataManager
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

public class rts_api_response_tec extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private String memberid;
  public String get_memberid() {
    return memberid;
  }
  public void set_memberid(String memberid) {
    this.memberid = memberid;
  }
  public rts_api_response_tec with_memberid(String memberid) {
    this.memberid = memberid;
    return this;
  }
  private String run_date;
  public String get_run_date() {
    return run_date;
  }
  public void set_run_date(String run_date) {
    this.run_date = run_date;
  }
  public rts_api_response_tec with_run_date(String run_date) {
    this.run_date = run_date;
    return this;
  }
  private String modelid;
  public String get_modelid() {
    return modelid;
  }
  public void set_modelid(String modelid) {
    this.modelid = modelid;
  }
  public rts_api_response_tec with_modelid(String modelid) {
    this.modelid = modelid;
    return this;
  }
  private String modelname;
  public String get_modelname() {
    return modelname;
  }
  public void set_modelname(String modelname) {
    this.modelname = modelname;
  }
  public rts_api_response_tec with_modelname(String modelname) {
    this.modelname = modelname;
    return this;
  }
  private String client;
  public String get_client() {
    return client;
  }
  public void set_client(String client) {
    this.client = client;
  }
  public rts_api_response_tec with_client(String client) {
    this.client = client;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof rts_api_response_tec)) {
      return false;
    }
    rts_api_response_tec that = (rts_api_response_tec) o;
    boolean equal = true;
    equal = equal && (this.memberid == null ? that.memberid == null : this.memberid.equals(that.memberid));
    equal = equal && (this.run_date == null ? that.run_date == null : this.run_date.equals(that.run_date));
    equal = equal && (this.modelid == null ? that.modelid == null : this.modelid.equals(that.modelid));
    equal = equal && (this.modelname == null ? that.modelname == null : this.modelname.equals(that.modelname));
    equal = equal && (this.client == null ? that.client == null : this.client.equals(that.client));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof rts_api_response_tec)) {
      return false;
    }
    rts_api_response_tec that = (rts_api_response_tec) o;
    boolean equal = true;
    equal = equal && (this.memberid == null ? that.memberid == null : this.memberid.equals(that.memberid));
    equal = equal && (this.run_date == null ? that.run_date == null : this.run_date.equals(that.run_date));
    equal = equal && (this.modelid == null ? that.modelid == null : this.modelid.equals(that.modelid));
    equal = equal && (this.modelname == null ? that.modelname == null : this.modelname.equals(that.modelname));
    equal = equal && (this.client == null ? that.client == null : this.client.equals(that.client));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.memberid = JdbcWritableBridge.readString(1, __dbResults);
    this.run_date = JdbcWritableBridge.readString(2, __dbResults);
    this.modelid = JdbcWritableBridge.readString(3, __dbResults);
    this.modelname = JdbcWritableBridge.readString(4, __dbResults);
    this.client = JdbcWritableBridge.readString(5, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.memberid = JdbcWritableBridge.readString(1, __dbResults);
    this.run_date = JdbcWritableBridge.readString(2, __dbResults);
    this.modelid = JdbcWritableBridge.readString(3, __dbResults);
    this.modelname = JdbcWritableBridge.readString(4, __dbResults);
    this.client = JdbcWritableBridge.readString(5, __dbResults);
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
    JdbcWritableBridge.writeString(memberid, 1 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(run_date, 2 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(modelid, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(modelname, 4 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(client, 5 + __off, 12, __dbStmt);
    return 5;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(memberid, 1 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(run_date, 2 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(modelid, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(modelname, 4 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(client, 5 + __off, 12, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.memberid = null;
    } else {
    this.memberid = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.run_date = null;
    } else {
    this.run_date = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.modelid = null;
    } else {
    this.modelid = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.modelname = null;
    } else {
    this.modelname = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.client = null;
    } else {
    this.client = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.memberid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, memberid);
    }
    if (null == this.run_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, run_date);
    }
    if (null == this.modelid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, modelid);
    }
    if (null == this.modelname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, modelname);
    }
    if (null == this.client) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, client);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.memberid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, memberid);
    }
    if (null == this.run_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, run_date);
    }
    if (null == this.modelid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, modelid);
    }
    if (null == this.modelname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, modelname);
    }
    if (null == this.client) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, client);
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
    __sb.append(FieldFormatter.escapeAndEnclose(memberid==null?"null":memberid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(run_date==null?"null":run_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(modelid==null?"null":modelid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(modelname==null?"null":modelname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(client==null?"null":client, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(memberid==null?"null":memberid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(run_date==null?"null":run_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(modelid==null?"null":modelid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(modelname==null?"null":modelname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(client==null?"null":client, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 124, (char) 10, (char) 0, (char) 0, false);
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
    if (__cur_str.equals("null")) { this.memberid = null; } else {
      this.memberid = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.run_date = null; } else {
      this.run_date = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.modelid = null; } else {
      this.modelid = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.modelname = null; } else {
      this.modelname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.client = null; } else {
      this.client = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.memberid = null; } else {
      this.memberid = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.run_date = null; } else {
      this.run_date = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.modelid = null; } else {
      this.modelid = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.modelname = null; } else {
      this.modelname = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.client = null; } else {
      this.client = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    rts_api_response_tec o = (rts_api_response_tec) super.clone();
    return o;
  }

  public void clone0(rts_api_response_tec o) throws CloneNotSupportedException {
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("memberid", this.memberid);
    __sqoop$field_map.put("run_date", this.run_date);
    __sqoop$field_map.put("modelid", this.modelid);
    __sqoop$field_map.put("modelname", this.modelname);
    __sqoop$field_map.put("client", this.client);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("memberid", this.memberid);
    __sqoop$field_map.put("run_date", this.run_date);
    __sqoop$field_map.put("modelid", this.modelid);
    __sqoop$field_map.put("modelname", this.modelname);
    __sqoop$field_map.put("client", this.client);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("memberid".equals(__fieldName)) {
      this.memberid = (String) __fieldVal;
    }
    else    if ("run_date".equals(__fieldName)) {
      this.run_date = (String) __fieldVal;
    }
    else    if ("modelid".equals(__fieldName)) {
      this.modelid = (String) __fieldVal;
    }
    else    if ("modelname".equals(__fieldName)) {
      this.modelname = (String) __fieldVal;
    }
    else    if ("client".equals(__fieldName)) {
      this.client = (String) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
  public boolean setField0(String __fieldName, Object __fieldVal) {
    if ("memberid".equals(__fieldName)) {
      this.memberid = (String) __fieldVal;
      return true;
    }
    else    if ("run_date".equals(__fieldName)) {
      this.run_date = (String) __fieldVal;
      return true;
    }
    else    if ("modelid".equals(__fieldName)) {
      this.modelid = (String) __fieldVal;
      return true;
    }
    else    if ("modelname".equals(__fieldName)) {
      this.modelname = (String) __fieldVal;
      return true;
    }
    else    if ("client".equals(__fieldName)) {
      this.client = (String) __fieldVal;
      return true;
    }
    else {
      return false;    }
  }
}
