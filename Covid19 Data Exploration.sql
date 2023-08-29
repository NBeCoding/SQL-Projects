

Select * from CovidDeths order by 3,4

Select * from CovidVac order by 3,4

-- Select data that we are goin to be using
Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeths 
order by 1,2

-- Loking at total cases vs total deths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPresentage
from CovidDeths 
where location = 'sri lanka'
order by 1,2


-- Total cases vs population
Select location, date, total_cases, population,(total_cases/population)*100 as DethPresentage
from CovidDeths 
where location = 'sri lanka'
order by 1,2

-- Highest infaction rate countries

Select location, MAX(total_cases) as HigestInf , population,MAX((total_cases/population)*100) as InfactPrecentage
from CovidDeths 
--where location = 'sri lanka' 
Group by population, location
order by InfactPrecentage desc

-- Showing countries with highest death count per population

Select location, MAX(total_deaths) as HigestDeaths 
from CovidDeths 
--where location = 'sri lanka' 
where continent is not null
Group by location
order by HigestDeaths desc

-- Showing total deaths by continent

Select continent, MAX(total_deaths) as HigestDeaths 
from CovidDeths 
--where location = 'sri lanka' 
where continent is not null
Group by continent
order by HigestDeaths desc

-- Global Numbers

Select sum(new_cases) as Total_Cases,sum(new_deaths) as Total_deaths, (sum(new_deaths)/Nullif(sum(new_cases),0))*100 as DethPresentage
from CovidDeths 
--where location = 'sri lanka'
where continent is not null
--Group by date
order by 1,2


Select * from CovidVac
order by location

-- Total population vs Vaccinated

select dea.continent, dea.location, dea.date, dea.population , CovidVac.new_vaccinations , SUM(cast(CovidVac.new_vaccinations as float))
over (partition by dea.location order by dea.location,dea.date) as RollingVaccinated 
from CovidDeths dea
join CovidVac
	on dea.location= CovidVac.location and dea.date=CovidVac.date
	where dea.continent is not null
order by 2,3


-- Use CTE

With PopvsVac (continent, location, date,population, new_vaccinations, RollingVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population , CovidVac.new_vaccinations , SUM(cast(CovidVac.new_vaccinations as float))
over (partition by dea.location order by dea.location,dea.date) as RollingVaccinated 
from CovidDeths dea
join CovidVac
	on dea.location= CovidVac.location and dea.date=CovidVac.date
	where dea.continent is not null
--order by 2,3
)
Select *, (RollingVaccinated / population)*100
from PopvsVac



-- Temp Table 


Drop table if exists #precentPopulationVaccinated
Create table #precentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population Numeric,
New_vaccinations numeric,
RollingVaccinated numeric
)

insert into #precentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population , CovidVac.new_vaccinations , SUM(cast(CovidVac.new_vaccinations as float))
over (partition by dea.location order by dea.location,dea.date) as RollingVaccinated 
from CovidDeths dea
join CovidVac
	on dea.location= CovidVac.location and dea.date=CovidVac.date
	where dea.continent is not null
--order by 2,3

Select *, (RollingVaccinated / population)*100
from #precentPopulationVaccinated


-- Create view to store date for later visulaizatons

Create view precentPopulationVaccinated 
as
select dea.continent, dea.location, dea.date, dea.population , CovidVac.new_vaccinations , SUM(cast(CovidVac.new_vaccinations as float))
over (partition by dea.location order by dea.location,dea.date) as RollingVaccinated 
from CovidDeths dea
join CovidVac
	on dea.location= CovidVac.location and dea.date=CovidVac.date
	where dea.continent is not null
--order by 2,3