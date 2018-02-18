import sqlContext.implicits._
val sqlCtx = new org.apache.spark.sql.SQLContext(sc)
case class ChicagoEmployeeSalary(lname:String, fname:String, title:String, department:String, salary:Double)
// tranformation
val csvfile =  sc.textFile("dfs/input/raw/chicago/chicago_employee_salaries_and_titles.csv")
val employeeRDD = csvfile.map(_.split(",")).map(p => ChicagoEmployeeSalary(p(0).trim, p(1).trim, p(2), p(3), p(4).trim.toDouble))
employeeRDD.toDebugString
employeeRDD.first()
// mapped RDD
val employeeNameRDD = employeeRDD.map(p => (p.lname, p.fname))
employeeNameRDD.saveAsSequenceFile("dfs/output/chicago/chicago_employee_names.seq")
// grouped by last names
val employeeByLastNameRDD = employeeNameRDD.groupByKey()
employeeByLastNameRDD.first()
employeeByLastNameRDD.count()
// RDD2DF
val employeeDF = employeeRDD.toDF()
// parquet
employeeDF.write.parquet("dfs/output/chicago/chicago_employee_salaries_and_titles.parquet")
employeeDF.explain
val parquetFile = sqlCtx.read.parquet("dfs/output/chicago/chicago_employee_salaries_and_titles.parquet")
parquetFile.printSchema()
parquetFile.registerTempTable("employeePTB")
// action
val fatcats = sqlCtx.sql("SELECT lname, fname, salary FROM employeePTB WHERE salary >= 100000.0")
fatcats.count()
fatcats.show()
val fatcats2 = sqlCtx.sql("SELECT lname, fname, salary FROM employeePTB WHERE salary >= 200000.0")
fatcats2.count()
fatcats2.show()
fatcats2.rdd.saveAsTextFile("dfs/output/chicago/fatcats2.txt")
// json
employeeDF.write.json("dfs/output/chicago/chicago_employee_salaries_and_titles.json")
val jsonFile = sqlCtx.read.json("dfs/output/chicago/chicago_employee_salaries_and_titles.json")
jsonFile.printSchema()
jsonFile.registerTempTable("employeeJTB")
// action
val slimcats = sqlCtx.sql("SELECT lname, fname, salary FROM employeeJTB WHERE salary <= 50000.0")
slimcats.count()
slimcats.show()
val slimcats2 = sqlCtx.sql("SELECT lname, fname, salary FROM employeeJTB WHERE salary <= 25000.0")
slimcats2.count()
slimcats2.show()
