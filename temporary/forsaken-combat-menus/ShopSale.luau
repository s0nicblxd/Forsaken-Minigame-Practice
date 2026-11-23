local Sale={}
function Sale.GetAssetPrice(_,config)
 local price=config.Price or 0
 return {IsDiscounted=false,OriginalPrice=price,FinalPrice=price}
end
function Sale.GetPrice(_,_,config)return Sale.GetAssetPrice(nil,config)end
function Sale.GetNextChangeTime()return nil end
function Sale.IsActive()return false end
return Sale
