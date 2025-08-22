select *
from [Portfoilio Projects].dbo.NashvilleHousing
--where PropertyAddress is null

--Change the sales Date into just Date type...

select SaleDate, CONVERT(Date, SaleDate) as SalesDate2
from [Portfoilio Projects].dbo.[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add SalesDates Nvarchar(255);

--ALTER TABLE NashvilleHousing
--DROP COLUMN SalesDates

Update NashvilleHousing
SET SalesDates = CONVERT(Date, SaleDate)

--Update NashvilleHousing
--Set SaleDate = CONVERT(Date, SaleDate)

-------------------------------------------

-- Populate Property Address data

Select *
From [Portfoilio Projects].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select housing1.ParcelID, housing1.PropertyAddress, housing2.ParcelID, housing2.PropertyAddress, ISNULL(housing1.PropertyAddress,housing2.PropertyAddress)
From [Portfoilio Projects].dbo.NashvilleHousing housing1
JOIN [Portfoilio Projects].dbo.NashvilleHousing housing2
	on housing1.ParcelID = housing2.ParcelID
	AND housing1.[UniqueID ] <> housing2.[UniqueID ]
Where housing1.PropertyAddress is null


Update housing1
SET PropertyAddress = ISNULL(housing1.PropertyAddress,housing2.PropertyAddress)
From [Portfoilio Projects].dbo.NashvilleHousing housing1
JOIN [Portfoilio Projects].dbo.NashvilleHousing housing2
	on housing1.ParcelID = housing2.ParcelID
	AND housing1.[UniqueID ] <> housing2.[UniqueID ]
Where housing1.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, states)


Select PropertyAddress
From [Portfoilio Projects].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from [Portfoilio Projects].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


ALTER TABLE NashvilleHousing
Add PropertySplitState Nvarchar(255);

Update NashvilleHousing
SET PropertySplitState = SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress)  + 12 , LEN(OwnerAddress))



select *
from [Portfoilio Projects].dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Portfoilio Projects].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


select SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
from [Portfoilio Projects].dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


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

from [Portfoilio Projects].dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- This sql querry is used to delete the Duplicates values from our Database
--Delete 
--From RowNumCTE
--Where row_num >1



Select *
from [Portfoilio Projects].dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
from [Portfoilio Projects].dbo.NashvilleHousing


ALTER TABLE [Portfoilio Projects].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

---------------------------------------------------------------------------------------------------------

-- Count what type of Family have Land..

Select Distinct(LandUse), COUNT(LandUse) As FamilyLandUsed
From [Portfoilio Projects].dbo.NashvilleHousing
Group by LandUse

