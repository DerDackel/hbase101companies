import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'org.apache.hadoop.hbase.client.Scan'
import 'org.apache.hadoop.hbase.util.Bytes'
import 'java.util.Arrays'

def jbytes(*args)
  args.map {|arg| arg.to_s.to_java_bytes}
end

employees = HTable.new(@hbase.configuration, "meganalysis_employees")
#depts = HTable.new(@hbase.configuration, "meganalysis_depts")

scanner = employees.getScanner(Scan.new)

putput = Put.new(*jbytes("007"))
putput.add(*(jbytes("corporate", "salary") << Bytes.toBytes(2344.0)))
employees.put(putput)
employees.flushCommits()

while (result = scanner.next())
  salary = Bytes.toDouble(result.getValue( *jbytes('corporate', 'salary')), 0)

  put_cut = Put.new(namebytes)
  put_cut.add( *(jbytes('corporate', 'salary') << Bytes.toBytes(salary / 2.0)))
  employees.put(put_cut) if put_cut
end
