Select *
From PortfolioProject..covidDeaths$
Where continent is not null
order by 3,4

Select *
From PortfolioProject..covidVaccinations$
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..covidDeaths$
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 percentage
From PortfolioProject..covidDeaths$
Where continent is not null
where location like '%india'
Where continent is not null
order by 1,2


Select location, date, total_cases, population, (total_cases/population)*100 populationpercentage
From PortfolioProject..covidDeaths$
--where location like '%india'
order by 1,2


Select location, MAX(total_cases) as highestinfectionCount, population, MAX((total_cases/population))*100 populationpercentage
From PortfolioProject..covidDeaths$
--where location like '%india'
Group by location,population
order by populationpercentage desc


Select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..covidDeaths$
Where location like '%india'
Where continent is not null
Group by continent
order by totalDeathCount desc



--Showing the continent with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..covidDeaths$
--Where location like '%india' 
Where continent is not null
Group by continent
order by totalDeathCount desc

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..covidDeaths$
Where location like '%india' 
Where continent is not null
Group by date

-- Looking at Total Population and Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by  dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
From PortfolioProject..covidDeaths$ dea
Join PortfolioProject..covidVaccinations$ vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths$ dea
Join PortfolioProject..covidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths$ dea
Join PortfolioProject..covidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualization

Create View #PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths$ dea
Join PortfolioProject..covidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 







