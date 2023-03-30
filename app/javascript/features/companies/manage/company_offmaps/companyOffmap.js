export const createCompanyOffmap = (id, availableOffmap) => ({
  id: id,
  availableOffmapId: availableOffmap.id,
  mun: availableOffmap.mun
})
