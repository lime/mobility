=begin

Add +blank?+, +present?+ and +presence+ methods to +Object+ class if
activesupport cannot be loaded.

=end
class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end

  def presence
    self if present?
  end
end

=begin

Add +blank?+ method to +NilClass+ in case activesupport cannot be loaded.

=end
class NilClass
  def blank?
    true
  end
end
