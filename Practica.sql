--LAB 3
--1
select top 3 count(SalesLT.Address.City),SalesLT.Address.City from SalesLT.Address
group by SalesLT.Address.City
order by count(SalesLT.Address.City)desc
--2
select count(SalesLT.Address.PostalCode) from SalesLT.Address
where PostalCode like 'M%'
--3
select top 1 count(SalesLT.Customer.CompanyName),SalesLT.Customer.CompanyName from SalesLT.Customer
group by SalesLT.Customer.CompanyName
order by count(SalesLT.Customer.CompanyName) desc
--4
select count(1) from SalesLT.CustomerAddress
where AddressType='Shipping'
--5
select top 1 SalesLT.Product.ListPrice from SalesLT.Product
order by SalesLT.Product.ListPrice asc
--6A
select AVG(SalesLT.Product.Weight) from SalesLT.Product
group by SalesLT.Product.ProductCategoryID
--6B--CTE
with CTE(promedio)
as(select AVG(SalesLT.Product.Weight) from SalesLT.Product
group by SalesLT.Product.ProductCategoryID)
select COUNT(1) from CTE WHERE CTE.promedio>0
--7
select count(1) from SalesLT.Customer
where CompanyName like '%Road%'
--8
select (SalesLT.Product.ListPrice-SalesLT.Product.StandardCost) as [diferencia], SalesLT.Product.ProductID 
from SalesLT.Product
--9
select top 1 count(SalesLT.Product.Color), SalesLT.Product.Color
from SalesLT.Product
group by SalesLT.Product.Color 
order by count(SalesLT.Product.Color) desc
--10 --en base a TotalDue
select avg(SalesLT.salesorderheader.totaldue) from SalesLT.salesorderheader
--11
select top 1 SalesLT.SalesOrderHeader.CustomerID from SalesLT.SalesOrderHeader
order by SalesLT.SalesOrderHeader.TaxAmt desc
--12--venta mas baja en costo total 
select top 1 SalesLT.SalesOrderHeader.SalesOrderID from SalesLT.SalesOrderHeader
order by SalesLT.SalesOrderHeader.TotalDue asc
--13A
select sum(SalesLT.SalesOrderHeader.TotalDue)as[Total por compras], SalesLT.SalesOrderHeader.CustomerID from SalesLT.SalesOrderHeader
group by SalesLT.SalesOrderHeader.CustomerID
--13B--CTE
with CTE (total, Id)
as(select sum(SalesLT.SalesOrderHeader.TotalDue)as[Total por compras], SalesLT.SalesOrderHeader.CustomerID from SalesLT.SalesOrderHeader
group by SalesLT.SalesOrderHeader.CustomerID)
select count(1) from CTE 
where Total>50000
--14
select top 1 sum(SalesLT.SalesOrderDetail.OrderQty)as [Unidades vendidas], SalesLT.SalesOrderDetail.ProductID from SalesLT.SalesOrderDetail
group by SalesLT.SalesOrderDetail.ProductID
order by sum(SalesLT.SalesOrderDetail.OrderQty) desc
--15A
select sum(SalesLT.SalesOrderDetail.OrderQty) as [Cantidad por venta] from SalesLT.SalesOrderDetail
group by SalesLT.SalesOrderDetail.SalesOrderID
--15B--CTE
with CTE (cantidad)
as(select sum(SalesLT.SalesOrderDetail.OrderQty) as [Cantidad por venta] from SalesLT.SalesOrderDetail
group by SalesLT.SalesOrderDetail.SalesOrderID)
select count(1) from CTE
where CTE.cantidad>8

--LAB4
--1--https://stackoverrun.com/es/q/2126266
SELECT (Customer.FirstName+COALESCE(Customer.MiddleName,' ')+Customer.LastName)as [Nombre completo],Header.CustomerID, Header.TotalDue as [Total de factura], Address.AddressLine1 as [direccion] 
from SalesLT.SalesOrderHeader Header inner join SalesLT.Customer Customer
on Header.CustomerID=Customer.CustomerID
inner join SalesLT.Address
on Header.BillToAddressID=Address.AddressID
--2
select SalesLT.Address.AddressLine1 from SalesLT.Customer inner join SalesLT.CustomerAddress
on SalesLT.Customer.CustomerID=SalesLT.CustomerAddress.CustomerID
inner join SalesLT.Address
on SalesLT.CustomerAddress.AddressID=SalesLT.Address.AddressID
where SalesLT.Customer.CompanyName='Future bike' or SalesLT.Customer.CompanyName='futuristic bikes'
--3
select detail.OrderQty as [cantidad], product.Name, detail.linetotal
from SalesLT.SalesOrderHeader header inner join SalesLT.SalesOrderDetail detail 
on header.SalesOrderID = detail.SalesOrderID
inner join SalesLT.Product product
on detail.ProductID = product.ProductID
where header.CustomerID = 29796
--3--extra--CTE
with CTE(cantidad)
as (select detail.OrderQty as [cantidad]
from SalesLT.SalesOrderHeader header inner join SalesLT.SalesOrderDetail detail 
on header.SalesOrderID = detail.SalesOrderID
where header.CustomerID = 29796)
select sum(cantidad) from CTE
--4
select custromer.CompanyName from saleslt.customer custromer inner join saleslt.customeraddress caddress
on custromer.CustomerID=caddress.customerid
inner join saleslt.Address
on Address.AddressID=caddress.AddressID
where Address.City='Vancouver'
--5
select count(1) from SalesLT.SalesOrderDetail
where SalesLT.SalesOrderDetail.LineTotal<1200
--6
select SalesLT.Customer.CompanyName from SalesLT.SalesOrderHeader inner join SalesLT.Customer
on SalesLT.SalesOrderHeader.CustomerID=SalesLT.Customer.CustomerID
where SalesLT.SalesOrderHeader.TotalDue<12000
--7--CTE
with CTE (cantidad, compañia)
as(select SalesLT.SalesOrderDetail.OrderQty,SalesLT.Customer.CompanyName from SalesLT.Customer inner join SalesLT.SalesOrderHeader
on SalesLT.Customer.CustomerID=SalesLT.SalesOrderHeader.CustomerID
inner join SalesLT.SalesOrderDetail
on SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID
inner join SalesLT.Product
on SalesLT.SalesOrderDetail.ProductID=SalesLT.Product.ProductID
where SalesLT.Product.Name='Long-Sleeve Logo Jersey, XL')
select CTE.cantidad from CTE
where CTE.compañia='Action Bicycle Specialists'
--8--CTE
with CTE (cantidad, #orden)
as(select sum(SalesLT.SalesOrderDetail.OrderQty),SalesLT.SalesOrderDetail.SalesOrderID
from SalesLT.SalesOrderDetail 
where SalesLT.SalesOrderDetail.OrderQty=1
group by SalesLT.SalesOrderDetail.SalesOrderID)
select CTE.cantidad,CTE.#orden,SalesLT.SalesOrderDetail.UnitPrice from CTE inner join SalesLT.SalesOrderDetail
on CTE.#orden= SalesLT.SalesOrderDetail.SalesOrderID
where cantidad=1
--9
select SalesLT.Customer.CompanyName, SalesLT.SalesOrderHeader.SubTotal, SalesLT.Product.Weight
from SalesLT.SalesOrderHeader inner join SalesLT.SalesOrderDetail
on SalesLT.SalesOrderHeader.SalesOrderID=SalesLT.SalesOrderDetail.SalesOrderID
inner join SalesLT.Customer
on SalesLT.SalesOrderHeader.CustomerID=SalesLT.Customer.CustomerID
inner join SalesLT.Product
on SalesLT.SalesOrderDetail.ProductID=SalesLT.Product.ProductID
order by SalesLT.SalesOrderHeader.SubTotal asc
--10--cte--se puede optimizar pasando algunos join despues del cte 
with CTE (cantidad, categoria)
as(
select Detail.OrderQty, category.Name from SalesLT.ProductCategory category inner join SalesLT.Product product
on category.ProductCategoryID=product.ProductCategoryID
inner join SalesLT.SalesOrderDetail Detail
on product.ProductID = detail.ProductID
inner join SalesLT.SalesOrderHeader Header 
on Detail.SalesOrderID = Header.SalesOrderID
inner join SalesLT.CustomerAddress addressc
on Header.CustomerID = addressc.CustomerID
inner join SalesLT.Address address
on addressc.AddressID=address.AddressID
where address.City='London')
select sum(cantidad) from CTE
where CTE.categoria='Gloves'

--LAB 5
--1
CREATE VIEW vista
as
select header.SalesOrderID,(Customer.FirstName+COALESCE(Customer.MiddleName,' ')+Customer.LastName)as [Nombre completo],(address.AddressLine1+address.City+address.StateProvince+address.CountryRegion+address.PostalCode)as [Direccion],
detail.OrderQty,header.TotalDue
from SalesLT.SalesOrderHeader header inner join SalesLT.Customer customer
on Header.CustomerID=customer.CustomerID
inner join SalesLT.CustomerAddress caddress
on customer.CustomerID=caddress.CustomerID
inner join SalesLT.Address address
on address.AddressID=caddress.AddressID
inner join SalesLT.SalesOrderDetail detail
on detail.SalesOrderID=header.SalesOrderID;
go 

select * from vista

drop view vista

--2--es necesario ejecutar todo el cursor desde que se decalra la variable hasta antes de cerrarlo para que funcione
create table #temp (total int, subtotal int, tax int, freight int,orden int)
insert into #temp (total, subtotal, tax, freight,orden) 
select sum(TotalDue) as [Total], sum(SubTotal) as [subtotal], sum(TaxAmt)as [tax], sum(Freight)as [freight], SalesOrderID as orden
from SalesLT.SalesOrderHeader 
group by SalesOrderID


create table #temp2 (total int, total2 int, orden int)
insert into #temp2(total, total2, orden)
select total,(subtotal+tax+freight), orden from #temp



declare @total int,@total2 int ,@orden int
declare curso cursor for 
select * from #temp2
open curso
fetch next from curso into @total, @total2,@orden
while @@FETCH_STATUS=0
begin 
if @total>0 and @total<5000
begin
set @total=@total*0.95
end
if @total>5001 and @total<10000
begin
set @total=@total*0.90
end
if @total>10001 and @total<25000
begin
set @total=@total*0.85
end
if @total>25000
begin
set @total=@total*0.80
end
print ('Orden: '+cast(@orden as nvarchar)+', Total nuevo: '+cast(@total as nvarchar)+', Total anterior: '+cast(@total2 as nvarchar))
fetch next from curso into @total, @total2, @orden
end 
close curso 
deallocate curso

drop table #temp

drop table #temp2