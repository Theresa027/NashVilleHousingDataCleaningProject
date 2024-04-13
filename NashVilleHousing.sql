/*

Cleaning Data in SQL Queries

*/


Select *
From SQLPortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format
ALTER TABLE NashvilleHousing
Add NewSaleDate Date;

Update NashvilleHousing
SET NewSaleDate = SaleDate

select NewSaleDate
from NashVilleHousing

--To Populate Property Address data and fill in  NULL values

Select Propertyaddress, ParcelID
From SQLPortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress) Property_Address
From SQLPortfolioProject.dbo.NashvilleHousing A
JOIN SQLPortfolioProject.dbo.NashvilleHousing B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is null


Update A
set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
From SQLPortfolioProject.dbo.NashvilleHousing A
JOIN SQLPortfolioProject.dbo.NashvilleHousing B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is null

--To see effected changes
Select PropertyAddress
From SQLPortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is NOT NULL
--order by ParcelID

--Partitioning PropertyAddress by street and city

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) Address
from SQLPortfolioProject.dbo.NashVilleHousing

Alter table sqlportfolioproject.dbo.NashvilleHousing
Add Addressbystreet Nvarchar(255);

Update sqlportfolioproject.dbo.NashvilleHousing
Set Addressbystreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter table sqlportfolioproject.dbo.NashvilleHousing
Add Address_City Nvarchar (255);

UPDATE sqlportfolioproject.dbo.NashvilleHousing
SET Address_city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--To see effected changes

SELECT *
from NashVilleHousing

--To Split OwnerAddress into Address ,City and State

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From SQLPortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

Alter table NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

Alter table NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);


UPDATE NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

UPDATE NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

UPDATE NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
From NashVilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT *
FROM NashVilleHousing

--To Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
--To delete duplicates
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--To remove unnecessary or unused columns
-- Delete Unused Columns

Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, Addressbycity




