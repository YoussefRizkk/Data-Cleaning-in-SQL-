/* 
Cleaning Data in SQL Quires 

*/ 

/* Standardize Date Form : TWO METHODS */
/* First Method */ 

Select SaleDate 
FROM [dbo].[NashvilleHousing ]

UPDATE [dbo].[NashvilleHousing ]
SET SaleDate = CONVERT(Date,SaleDate)

/* Second Method */

ALTER TABLE [dbo].[NashvilleHousing ]
Add SAlesDateConverted Date; 

UPDATE [dbo].[NashvilleHousing ]
SET SAlesDateConverted = convert(date,SaleDate)

SELECT SAlesDateConverted
FROM [dbo].[NashvilleHousing ]


/* Populate Property Address date */ 


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress )
FROM [dbo].[NashvilleHousing ] a
JOIN [dbo].[NashvilleHousing ] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null 

SELECT PropertyAddress
FROM [dbo].[NashvilleHousing ]
WHERe PropertyAddress is null 



/* Breaking out address into indivisual Columns ( ADDRESS,City,state) */ 

SELECT 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) Address   /*  substring(column name, starting point,endpoint) */
/* 3m n2ol select substring bl propertyaddress w 3m 7ddid index lal starting and endpoints: starting = 1 so from first word and end untill comma:
 so charindex bn2llo feha lwen bs yosl yw22f w b2yya column 3m nsht8l, fyyi bdl comma 7ot 2sm le bddi yeh, w hon 3m y3tini l index l2la , so k2n 3m 2llo ro7 shof 
 l comma 3a 2yya index w bs tosl la hyda l index w22f lsubstring,  */
from [dbo].[NashvilleHousing ]   /* bhydi lcase le comma 3m totl3 bl output so to stop that and since ana 3m 2o2f 3l index lal comma, so b2llo yo2f 3l index lal comma
-1 , as follows: */ 


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address
FROM [dbo].[NashvilleHousing ] 

/* Now, that I have the address in a separate column, we will do the same to have the city in a separate column: */ 

SELECT 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,lEN(PropertyAddress)) City 

FROM [dbo].[NashvilleHousing ]  

/* No need to write each one separated, we just did that to show cases, so the total code is */

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,lEN(PropertyAddress)) City 
FROM [dbo].[NashvilleHousing ] 


 
 /* All above were not the final steps, what we did is too see our results, but actually we need to put these results in our tbale, so: */ 

ALTER TABLE [dbo].[NashvilleHousing ]
Add location varchar(200), CITY varchar(200);

UPDATE [dbo].[NashvilleHousing ]
SET
location = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
CITY = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,lEN(PropertyAddress))

Select location,CITY 
FROM [dbo].[NashvilleHousing ]


/* Break OwnerAddress Column into address,city and state columns) : */
/*  Because we are still beginners, we will divide the column to three columns ( show how) then we will show the coding ( correct way from beginning) */ 

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) FINAL_ADDRESS, 
PARSENAME(REPLACE(OwnerAddress,',','.'),2) FINAL_CITY,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) FINAL_STATE
FROM [dbo].[NashvilleHousing ] 

/*  Usually we don't do the above, we just do the following:    */

ALTER TABLE [dbo].[NashvilleHousing ]
Add FINAL_ADDRESS varchar(200), FINAL_CITY varchar(200), FINAL_STATE varchar(200);

UPDATE [dbo].[NashvilleHousing ]
SET 
FINAL_ADDRESS = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
FINAL_CITY = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
FINAL_STATE = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

SELECT * 
FROM [dbo].[NashvilleHousing ] 


/* Change Y to yes and N to No, in 'Sold as Vacant' Column */ 

SELECT DISTINCT(SoldAsVacant)
FROM [dbo].[NashvilleHousing ]   /* WE have noticed from selecting the distinct that we have Y and N other than Yes and No */ 

/* more analysis; lets see the count of each one */ 

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM [dbo].[NashvilleHousing ]
GROUP BY SoldAsVacant
order by Count(SoldAsVacant) Desc   /* WE have 399 N and 52 Y */ 

/* As above, we will show how to convert alone, then we will use the complete coding: */ 

SELECT 
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant   /* y3ni if it is not N or Y then It is yes or no so keep it as it is */
	 END 
FROM [dbo].[NashvilleHousing ]   

/* Now we do the complete coding, we want to update our table : */ 

UPDATE [dbo].[NashvilleHousing ]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant   
	 END 

/* Now if we see the distinct values in sold as vacant column, I should get only Yes and No */ 

SELECT DISTINCT(SoldAsVacant)
FROM [dbo].[NashvilleHousing ]  


/* Remove Duplicates */ 

