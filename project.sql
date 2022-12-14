--import all rows where ColorID is above 20 to a data frame
--print the shape and size of the data frame
-- export the first 10 rows to a SQL Server result set

EXEC sp_execute_external_script
@language = N'Python';
@script = N'
print(InputDataSet.shape)
print(InputDataSet.size)

',
@input_data_1= N'SELECT ColorName, ColorID
from Warehouse.Colors
where ColorID>20;'


-- select CityID and CItyName from Application.Cities
-- Add the query to as Python scrits data frame
-- return 10 random records as a SQL result set

EXEC sp_execute_external_script
@language = N'Python';
@script = N'
OutputDataSet=InputDataSet.sample(10)
',
@input_data_1= N'SELECT CityID, CityName
from Application.Cities'
WITH RESULT SETS (([CityID] int, [CityName] nvarchar(50)));


-- Select Temperature From Warehouse.ColdRoomTemperatures
-- import Celsius measureents into Python
-- output a data frame with celsius and Farebheit values
--formula : F=(C *1,8)+32
import celsius;
EXEC sp_execute_external_script
@language = N'Python';
@script = N'

celsiusValues=InputData.iloc[:0]
farenheitValues=(celsiusValues*1.8)+32

df=pandas.DataFrame({"TempC":celsiumValues, "TempF":farenheitValues})
OutputDataSet= df
',
input_data_1=N'SELECT CONVERT(float, Temperature) AS Temp FROM Warehouse.ColdRoomTemperatures;'
WITH RESULT SETS(([Temp C] float,[Temp F] float))

-- Create stored procedure with parameterized Python script
CREATE PROCEDURE MyFavoriteCities
	@Quantity int
AS

EXEC sp_execute_external_script
@language = N'Python',
@script = N'
OutputDataSet = InputDataSet.sample(q)
',
@input_data_1 = N'SELECT CityID, CityName FROM Application.Cities',
@params = N'@q int',
@q = @Quantity
WITH RESULT SETS (([CityID] int, [CityName] nvarchar(50)));


-- Execute the stored procedure
EXEC MyFavoriteCities @Quantity = 15
