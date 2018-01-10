class LazyObject < ::BasicObject
  def initialize(&callable)
    @callable = callable
  end

  def __target_object__
    @__target_object__ ||= @callable.call
  end

  def method_missing(method_name, *args, &block)
    __target_object__.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    __target_object__.respond_to?(method_name) || super
  end

  def inspect
    __target_object__.inspect
  end
end
