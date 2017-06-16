class BinData::String
  def snapshot
    super.force_encoding('UTF-16LE')
  end
end
