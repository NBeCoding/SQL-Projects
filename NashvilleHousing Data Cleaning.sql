Select * from NashvilleHousing

-- Std Date format

	Select SaleDate, CONVERT(Date,SaleDate)
	from NashvilleHousing


	Alter Table NashvilleHousing
	Add SaleDateCon Date;

	Update NashvilleHousing
	Set SaleDateCon = CONVERT(date,SaleDate)

	
	Select SaleDateCon, CONVERT(Date,SaleDate)
	from NashvilleHousing


-- Populate Property adress data
	
	
	Select *
	from NashvilleHousing
	Order by ParcelID


		
	Select *
	from NashvilleHousing
	Where PropertyAddress is null
	Order by ParcelID

	Select a. ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress,b.PropertyAddress) 
	from NashvilleHousing a
	Join NashvilleHousing b
	on a.ParcelID=b.ParcelID and a.[UniqueID ] <> b. [UniqueID ]
	where a.PropertyAddress is null

	Update a
	set PropertyAddress = Isnull(a.PropertyAddress,b.PropertyAddress) 
	from NashvilleHousing a
	Join NashvilleHousing b
	on a.ParcelID=b.ParcelID and a.[UniqueID ] <> b. [UniqueID ]
	where a.PropertyAddress is null

-- Beaking out Addess onto individual columns

	Select SUBSTRING (PropertyAddress, 1, charindex(',',PropertyAddress)-1) As Address ,
	SUBSTRING (PropertyAddress, charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) As City
	from NashvilleHousing

	-- Create New Cloumns & Data

	ALTER TABLE NashvilleHousing
	Add SpiltPropertyAddress nvarchar(225)

	Update NashvilleHousing
	set SpiltPropertyAddress = SUBSTRING (PropertyAddress, 1, charindex(',',PropertyAddress)-1)

	Alter table NashvilleHousing 
	drop column PropertyAdress

	ALTER TABLE NashvilleHousing
	Add SpiltPropertyCity nvarchar(225)

	Update NashvilleHousing
	set SpiltPropertyCity  = SUBSTRING (PropertyAddress, charindex(',',PropertyAddress)+1, LEN(PropertyAddress))

-- Breaking out Ower Address in to Cloumns

	Select OwnerAddress
	From NashvilleHousing 

	Select 
	PARSENAME(replace(OwnerAddress,',','.'), 3),
	PARSENAME(replace(OwnerAddress,',','.'), 2),
	PARSENAME(replace(OwnerAddress,',','.'), 1)
	From NashvilleHousing 

-- Ading data to new Colums

	ALTER TABLE NashvilleHousing
	Add SpiltOwnerAddress nvarchar(225)

	ALTER TABLE NashvilleHousing
	Add SpiltOwnerCity nvarchar(225)

	ALTER TABLE NashvilleHousing
	Add SpiltOwnerState nvarchar(225)

	Select *
	from NashvilleHousing

	Update NashvilleHousing
	Set SpiltOwnerAddress = PARSENAME(replace(OwnerAddress,',','.'), 3)

	Update NashvilleHousing
	Set SpiltOwnerCity = PARSENAME(replace(OwnerAddress,',','.'), 2)

	Update NashvilleHousing
	Set SpiltOwnerState = PARSENAME(replace(OwnerAddress,',','.'), 1)

-- Change Y and N to Yes and No in 'Sold as vacant' field

	Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
	From NashvilleHousing
	Group by SoldAsVacant
	Order by 2

	Select SoldAsVacant, 
	Case When SoldAsVacant = 'Y' then 'Yes'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 END
	from NashvilleHousing


	Update NashvilleHousing
	Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 END
	From NashvilleHousing



-- Remove Duplicates


With RowNumCTE as (
Select *
, ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY UniqueID) row_num
from NashvilleHousing
)

Select * 
from RowNumCTE
Where row_num > 1

Select * 
from RowNumCTE
Where row_num > 1

Select * from NashvilleHousing


-- Delete Unused coloumns

Select * from NashvilleHousing

Alter Table NashvilleHousing
drop column SaleDate