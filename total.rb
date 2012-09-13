import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Scan'
import 'org.apache.hadoop.hbase.util.Bytes'

def jbytes(*args)
  args.map {|arg| arg.to_s.to_java_bytes}
end

employees = HTable.new(@hbase.configuration, "meganalysis_employees")
depts = HTable.new(@hbase.configuration, "meganalysis_depts")

scanner = employees.getScanner(Scan.new)

total = 0.0
while (result = scanner.next())
  id = Bytes.toString(result.getRow())
  name = Bytes.toString(result.getValue(*jbytes('personal', 'name')))
  salary = Bytes.toDouble(result.getValue( *jbytes('corporate', 'salary')))

  print "ID: #{id}, Name: #{name}, Salary: #{salary}\n"
  total += salary
end

print "Total: #{total}\n"
