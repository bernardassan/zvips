pub const ext = @import("ext.zig");
const gobject = @This();

const std = @import("std");
const compat = @import("compat");
const glib = @import("glib2");
/// This is the signature of marshaller functions, required to marshall
/// arrays of parameter values to signal emissions into C language callback
/// invocations.
///
/// It is merely an alias to `gobject.ClosureMarshal` since the `gobject.Closure` mechanism
/// takes over responsibility of actual function invocation for the signal
/// system.
pub const SignalCMarshaller = gobject.ClosureMarshal;

/// This is the signature of va_list marshaller functions, an optional
/// marshaller that can be used in some situations to avoid
/// marshalling the signal argument into GValues.
pub const SignalCVaMarshaller = gobject.VaClosureMarshal;

/// A numerical value which represents the unique identifier of a registered
/// type.
pub const Type = usize;

/// `GObject` instance (or source) and another property on another `GObject`
/// instance (or target).
///
/// Whenever the source property changes, the same value is applied to the
/// target property; for instance, the following binding:
///
/// ```c
///   g_object_bind_property (object1, "property-a",
///                           object2, "property-b",
///                           G_BINDING_DEFAULT);
/// ```
///
/// will cause the property named "property-b" of `object2` to be updated
/// every time `gobject.set` or the specific accessor changes the value of
/// the property "property-a" of `object1`.
///
/// It is possible to create a bidirectional binding between two properties
/// of two `GObject` instances, so that if either property changes, the
/// other is updated as well, for instance:
///
/// ```c
///   g_object_bind_property (object1, "property-a",
///                           object2, "property-b",
///                           G_BINDING_BIDIRECTIONAL);
/// ```
///
/// will keep the two properties in sync.
///
/// It is also possible to set a custom transformation function (in both
/// directions, in case of a bidirectional binding) to apply a custom
/// transformation from the source value to the target value before
/// applying it; for instance, the following binding:
///
/// ```c
///   g_object_bind_property_full (adjustment1, "value",
///                                adjustment2, "value",
///                                G_BINDING_BIDIRECTIONAL,
///                                celsius_to_fahrenheit,
///                                fahrenheit_to_celsius,
///                                NULL, NULL);
/// ```
///
/// will keep the "value" property of the two adjustments in sync; the
/// `celsius_to_fahrenheit` function will be called whenever the "value"
/// property of `adjustment1` changes and will transform the current value
/// of the property before applying it to the "value" property of `adjustment2`.
///
/// Vice versa, the `fahrenheit_to_celsius` function will be called whenever
/// the "value" property of `adjustment2` changes, and will transform the
/// current value of the property before applying it to the "value" property
/// of `adjustment1`.
///
/// Note that `gobject.Binding` does not resolve cycles by itself; a cycle like
///
/// ```
///   object1:propertyA -> object2:propertyB
///   object2:propertyB -> object3:propertyC
///   object3:propertyC -> object1:propertyA
/// ```
///
/// might lead to an infinite loop. The loop, in this particular case,
/// can be avoided if the objects emit the `GObject::notify` signal only
/// if the value has effectively been changed. A binding is implemented
/// using the `GObject::notify` signal, so it is susceptible to all the
/// various ways of blocking a signal emission, like `gobject.signalStopEmission`
/// or `gobject.signalHandlerBlock`.
///
/// A binding will be severed, and the resources it allocates freed, whenever
/// either one of the `GObject` instances it refers to are finalized, or when
/// the `gobject.Binding` instance loses its last reference.
///
/// Bindings for languages with garbage collection can use
/// `gobject.Binding.unbind` to explicitly release a binding between the source
/// and target properties, instead of relying on the last reference on the
/// binding, source, and target instances to drop.
pub const Binding = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = Binding;
    };
    pub const virtual_methods = struct {};

    pub const properties = struct {
        /// Flags to be used to control the `gobject.Binding`
        pub const flags = struct {
            pub const name = "flags";

            pub const Type = gobject.BindingFlags;
        };

        /// The `gobject.Object` that should be used as the source of the binding
        pub const source = struct {
            pub const name = "source";

            pub const Type = ?*gobject.Object;
        };

        /// The name of the property of `gobject.Binding.properties.source` that should be used
        /// as the source of the binding.
        ///
        /// This should be in [canonical form][canonical-parameter-names] to get the
        /// best performance.
        pub const source_property = struct {
            pub const name = "source-property";

            pub const Type = ?[*:0]u8;
        };

        /// The `gobject.Object` that should be used as the target of the binding
        pub const target = struct {
            pub const name = "target";

            pub const Type = ?*gobject.Object;
        };

        /// The name of the property of `gobject.Binding.properties.target` that should be used
        /// as the target of the binding.
        ///
        /// This should be in [canonical form][canonical-parameter-names] to get the
        /// best performance.
        pub const target_property = struct {
            pub const name = "target-property";

            pub const Type = ?[*:0]u8;
        };
    };

    pub const signals = struct {};

    /// Retrieves the `gobject.Object` instance used as the source of the binding.
    ///
    /// A `gobject.Binding` can outlive the source `gobject.Object` as the binding does not hold a
    /// strong reference to the source. If the source is destroyed before the
    /// binding then this function will return `NULL`.
    extern fn g_binding_dup_source(p_binding: *Binding) ?*gobject.Object;
    pub const dupSource = g_binding_dup_source;

    /// Retrieves the `gobject.Object` instance used as the target of the binding.
    ///
    /// A `gobject.Binding` can outlive the target `gobject.Object` as the binding does not hold a
    /// strong reference to the target. If the target is destroyed before the
    /// binding then this function will return `NULL`.
    extern fn g_binding_dup_target(p_binding: *Binding) ?*gobject.Object;
    pub const dupTarget = g_binding_dup_target;

    /// Retrieves the flags passed when constructing the `gobject.Binding`.
    extern fn g_binding_get_flags(p_binding: *Binding) gobject.BindingFlags;
    pub const getFlags = g_binding_get_flags;

    /// Retrieves the `gobject.Object` instance used as the source of the binding.
    ///
    /// A `gobject.Binding` can outlive the source `gobject.Object` as the binding does not hold a
    /// strong reference to the source. If the source is destroyed before the
    /// binding then this function will return `NULL`.
    ///
    /// Use `gobject.Binding.dupSource` if the source or binding are used from different
    /// threads as otherwise the pointer returned from this function might become
    /// invalid if the source is finalized from another thread in the meantime.
    extern fn g_binding_get_source(p_binding: *Binding) ?*gobject.Object;
    pub const getSource = g_binding_get_source;

    /// Retrieves the name of the property of `gobject.Binding.properties.source` used as the source
    /// of the binding.
    extern fn g_binding_get_source_property(p_binding: *Binding) [*:0]const u8;
    pub const getSourceProperty = g_binding_get_source_property;

    /// Retrieves the `gobject.Object` instance used as the target of the binding.
    ///
    /// A `gobject.Binding` can outlive the target `gobject.Object` as the binding does not hold a
    /// strong reference to the target. If the target is destroyed before the
    /// binding then this function will return `NULL`.
    ///
    /// Use `gobject.Binding.dupTarget` if the target or binding are used from different
    /// threads as otherwise the pointer returned from this function might become
    /// invalid if the target is finalized from another thread in the meantime.
    extern fn g_binding_get_target(p_binding: *Binding) ?*gobject.Object;
    pub const getTarget = g_binding_get_target;

    /// Retrieves the name of the property of `gobject.Binding.properties.target` used as the target
    /// of the binding.
    extern fn g_binding_get_target_property(p_binding: *Binding) [*:0]const u8;
    pub const getTargetProperty = g_binding_get_target_property;

    /// Explicitly releases the binding between the source and the target
    /// property expressed by `binding`.
    ///
    /// This function will release the reference that is being held on
    /// the `binding` instance if the binding is still bound; if you want to hold on
    /// to the `gobject.Binding` instance after calling `gobject.Binding.unbind`, you will need
    /// to hold a reference to it.
    ///
    /// Note however that this function does not take ownership of `binding`, it
    /// only unrefs the reference that was initially created by
    /// `gobject.Object.bindProperty` and is owned by the binding.
    extern fn g_binding_unbind(p_binding: *Binding) void;
    pub const unbind = g_binding_unbind;

    extern fn g_binding_get_type() usize;
    pub const getGObjectType = g_binding_get_type;

    extern fn g_object_ref(p_self: *gobject.Binding) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.Binding) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Binding, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// `GBindingGroup` can be used to bind multiple properties
/// from an object collectively.
///
/// Use the various methods to bind properties from a single source
/// object to multiple destination objects. Properties can be bound
/// bidirectionally and are connected when the source object is set
/// with `gobject.BindingGroup.setSource`.
pub const BindingGroup = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = BindingGroup;
    };
    pub const virtual_methods = struct {};

    pub const properties = struct {
        /// The source object used for binding properties.
        pub const source = struct {
            pub const name = "source";

            pub const Type = ?*gobject.Object;
        };
    };

    pub const signals = struct {};

    /// Creates a new `gobject.BindingGroup`.
    extern fn g_binding_group_new() *gobject.BindingGroup;
    pub const new = g_binding_group_new;

    /// Creates a binding between `source_property` on the source object
    /// and `target_property` on `target`. Whenever the `source_property`
    /// is changed the `target_property` is updated using the same value.
    /// The binding flag `G_BINDING_SYNC_CREATE` is automatically specified.
    ///
    /// See `gobject.Object.bindProperty` for more information.
    extern fn g_binding_group_bind(p_self: *BindingGroup, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags) void;
    pub const bind = g_binding_group_bind;

    /// Creates a binding between `source_property` on the source object and
    /// `target_property` on `target`, allowing you to set the transformation
    /// functions to be used by the binding. The binding flag
    /// `G_BINDING_SYNC_CREATE` is automatically specified.
    ///
    /// See `gobject.Object.bindPropertyFull` for more information.
    extern fn g_binding_group_bind_full(p_self: *BindingGroup, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags, p_transform_to: ?gobject.BindingTransformFunc, p_transform_from: ?gobject.BindingTransformFunc, p_user_data: ?*anyopaque, p_user_data_destroy: ?glib.DestroyNotify) void;
    pub const bindFull = g_binding_group_bind_full;

    /// Creates a binding between `source_property` on the source object and
    /// `target_property` on `target`, allowing you to set the transformation
    /// functions to be used by the binding. The binding flag
    /// `G_BINDING_SYNC_CREATE` is automatically specified.
    ///
    /// This function is the language bindings friendly version of
    /// `g_binding_group_bind_property_full`, using `GClosures`
    /// instead of function pointers.
    ///
    /// See `gobject.Object.bindPropertyWithClosures` for more information.
    extern fn g_binding_group_bind_with_closures(p_self: *BindingGroup, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags, p_transform_to: ?*gobject.Closure, p_transform_from: ?*gobject.Closure) void;
    pub const bindWithClosures = g_binding_group_bind_with_closures;

    /// Gets the source object used for binding properties.
    extern fn g_binding_group_dup_source(p_self: *BindingGroup) ?*gobject.Object;
    pub const dupSource = g_binding_group_dup_source;

    /// Sets `source` as the source object used for creating property
    /// bindings. If there is already a source object all bindings from it
    /// will be removed.
    ///
    /// Note that all properties that have been bound must exist on `source`.
    extern fn g_binding_group_set_source(p_self: *BindingGroup, p_source: ?*gobject.Object) void;
    pub const setSource = g_binding_group_set_source;

    extern fn g_binding_group_get_type() usize;
    pub const getGObjectType = g_binding_group_get_type;

    extern fn g_object_ref(p_self: *gobject.BindingGroup) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.BindingGroup) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *BindingGroup, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A type for objects that have an initially floating reference.
///
/// All the fields in the `GInitiallyUnowned` structure are private to the
/// implementation and should never be accessed directly.
pub const InitiallyUnowned = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = gobject.InitiallyUnownedClass;
    f_g_type_instance: gobject.TypeInstance,
    f_ref_count: c_uint,
    f_qdata: ?*glib.Data,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn g_initially_unowned_get_type() usize;
    pub const getGObjectType = g_initially_unowned_get_type;

    extern fn g_object_ref(p_self: *gobject.InitiallyUnowned) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.InitiallyUnowned) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *InitiallyUnowned, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The base object type.
///
/// `GObject` is the fundamental type providing the common attributes and
/// methods for all object types in GTK, Pango and other libraries
/// based on GObject. The `GObject` class provides methods for object
/// construction and destruction, property access methods, and signal
/// support. Signals are described in detail [here][gobject-Signals].
///
/// For a tutorial on implementing a new `GObject` class, see [How to define and
/// implement a new GObject](tutorial.html`how`-to-define-and-implement-a-new-gobject).
/// For a list of naming conventions for GObjects and their methods, see the
/// [GType conventions](concepts.html`conventions`). For the high-level concepts
/// behind GObject, read
/// [Instantiatable classed types: Objects](concepts.html`instantiatable`-classed-types-objects).
///
/// Since GLib 2.72, all `GObject`s are guaranteed to be aligned to at least the
/// alignment of the largest basic GLib type (typically this is `guint64` or
/// `gdouble`). If you need larger alignment for an element in a `GObject`, you
/// should allocate it on the heap (aligned), or arrange for your `GObject` to be
/// appropriately padded. This guarantee applies to the `GObject` (or derived)
/// struct, the `GObjectClass` (or derived) struct, and any private data allocated
/// by ``G_ADD_PRIVATE``.
pub const Object = extern struct {
    pub const Parent = gobject.TypeInstance;
    pub const Implements = [_]type{};
    pub const Class = gobject.ObjectClass;
    f_g_type_instance: gobject.TypeInstance,
    f_ref_count: c_uint,
    f_qdata: ?*glib.Data,

    pub const virtual_methods = struct {
        /// the `constructed` function is called by `gobject.Object.new` as the
        ///  final step of the object creation process.  At the point of the call, all
        ///  construction properties have been set on the object.  The purpose of this
        ///  call is to allow for object initialisation steps that can only be performed
        ///  after construction properties have been set.  `constructed` implementors
        ///  should chain up to the `constructed` call of their parent class to allow it
        ///  to complete its initialisation.
        pub const constructed = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_constructed.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_constructed = @ptrCast(p_implementation);
            }
        };

        /// emits property change notification for a bunch
        ///  of properties. Overriding `dispatch_properties_changed` should be rarely
        ///  needed.
        pub const dispatch_properties_changed = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_n_pspecs: c_uint, p_pspecs: **gobject.ParamSpec) void {
                return gobject.ext.as(Object.Class, p_class).f_dispatch_properties_changed.?(gobject.ext.as(Object, p_object), p_n_pspecs, p_pspecs);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_n_pspecs: c_uint, p_pspecs: **gobject.ParamSpec) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_dispatch_properties_changed = @ptrCast(p_implementation);
            }
        };

        /// the `dispose` function is supposed to drop all references to other
        ///  objects, but keep the instance otherwise intact, so that client method
        ///  invocations still work. It may be run multiple times (due to reference
        ///  loops). Before returning, `dispose` should chain up to the `dispose` method
        ///  of the parent class.
        pub const dispose = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_dispose.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_dispose = @ptrCast(p_implementation);
            }
        };

        /// instance finalization function, should finish the finalization of
        ///  the instance begun in `dispose` and chain up to the `finalize` method of the
        ///  parent class.
        pub const finalize = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_finalize.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_finalize = @ptrCast(p_implementation);
            }
        };

        /// the generic getter for all properties of this type. Should be
        ///  overridden for every type with properties.
        pub const get_property = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) void {
                return gobject.ext.as(Object.Class, p_class).f_get_property.?(gobject.ext.as(Object, p_object), p_property_id, p_value, p_pspec);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_get_property = @ptrCast(p_implementation);
            }
        };

        /// Emits a "notify" signal for the property `property_name` on `object`.
        ///
        /// When possible, eg. when signaling a property change from within the class
        /// that registered the property, you should use `gobject.Object.notifyByPspec`
        /// instead.
        ///
        /// Note that emission of the notify signal may be blocked with
        /// `gobject.Object.freezeNotify`. In this case, the signal emissions are queued
        /// and will be emitted (in reverse order) when `gobject.Object.thawNotify` is
        /// called.
        pub const notify = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_pspec: *gobject.ParamSpec) void {
                return gobject.ext.as(Object.Class, p_class).f_notify.?(gobject.ext.as(Object, p_object), p_pspec);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_pspec: *gobject.ParamSpec) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_notify = @ptrCast(p_implementation);
            }
        };

        /// the generic setter for all properties of this type. Should be
        ///  overridden for every type with properties. If implementations of
        ///  `set_property` don't emit property change notification explicitly, this will
        ///  be done implicitly by the type system. However, if the notify signal is
        ///  emitted explicitly, the type system will not emit it a second time.
        pub const set_property = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) void {
                return gobject.ext.as(Object.Class, p_class).f_set_property.?(gobject.ext.as(Object, p_object), p_property_id, p_value, p_pspec);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_set_property = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {
        /// The notify signal is emitted on an object when one of its properties has
        /// its value set through `gobject.Object.setProperty`, `gobject.Object.set`, et al.
        ///
        /// Note that getting this signal doesn’t itself guarantee that the value of
        /// the property has actually changed. When it is emitted is determined by the
        /// derived GObject class. If the implementor did not create the property with
        /// `G_PARAM_EXPLICIT_NOTIFY`, then any call to `gobject.Object.setProperty` results
        /// in ::notify being emitted, even if the new value is the same as the old.
        /// If they did pass `G_PARAM_EXPLICIT_NOTIFY`, then this signal is emitted only
        /// when they explicitly call `gobject.Object.notify` or `gobject.Object.notifyByPspec`,
        /// and common practice is to do that only when the value has actually changed.
        ///
        /// This signal is typically used to obtain change notification for a
        /// single property, by specifying the property name as a detail in the
        /// `g_signal_connect` call, like this:
        ///
        /// ```
        /// g_signal_connect (text_view->buffer, "notify::paste-target-list",
        ///                   G_CALLBACK (gtk_text_view_target_list_notify),
        ///                   text_view)
        /// ```
        ///
        /// It is important to note that you must use
        /// [canonical parameter names]`gobject.@"ParamSpec#parameter-names"` as
        /// detail strings for the notify signal.
        pub const notify = struct {
            pub const name = "notify";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_pspec: *gobject.ParamSpec, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Object, p_instance))),
                    gobject.signalLookup("notify", Object.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    extern fn g_object_compat_control(p_what: usize, p_data: ?*anyopaque) usize;
    pub const compatControl = g_object_compat_control;

    /// Find the `gobject.ParamSpec` with the given name for an
    /// interface. Generally, the interface vtable passed in as `g_iface`
    /// will be the default vtable from `gobject.typeDefaultInterfaceRef`, or,
    /// if you know the interface has already been loaded,
    /// `gobject.typeDefaultInterfacePeek`.
    extern fn g_object_interface_find_property(p_g_iface: *gobject.TypeInterface, p_property_name: [*:0]const u8) *gobject.ParamSpec;
    pub const interfaceFindProperty = g_object_interface_find_property;

    /// Add a property to an interface; this is only useful for interfaces
    /// that are added to GObject-derived types. Adding a property to an
    /// interface forces all objects classes with that interface to have a
    /// compatible property. The compatible property could be a newly
    /// created `gobject.ParamSpec`, but normally
    /// `gobject.ObjectClass.overrideProperty` will be used so that the object
    /// class only needs to provide an implementation and inherits the
    /// property description, default value, bounds, and so forth from the
    /// interface property.
    ///
    /// This function is meant to be called from the interface's default
    /// vtable initialization function (the `class_init` member of
    /// `gobject.TypeInfo`.) It must not be called after after `class_init` has
    /// been called for any object types implementing this interface.
    ///
    /// If `pspec` is a floating reference, it will be consumed.
    extern fn g_object_interface_install_property(p_g_iface: *gobject.TypeInterface, p_pspec: *gobject.ParamSpec) void;
    pub const interfaceInstallProperty = g_object_interface_install_property;

    /// Lists the properties of an interface.Generally, the interface
    /// vtable passed in as `g_iface` will be the default vtable from
    /// `gobject.typeDefaultInterfaceRef`, or, if you know the interface has
    /// already been loaded, `gobject.typeDefaultInterfacePeek`.
    extern fn g_object_interface_list_properties(p_g_iface: *gobject.TypeInterface, p_n_properties_p: *c_uint) [*]*gobject.ParamSpec;
    pub const interfaceListProperties = g_object_interface_list_properties;

    /// Creates a new instance of a `gobject.Object` subtype and sets its properties.
    ///
    /// Construction parameters (see `G_PARAM_CONSTRUCT`, `G_PARAM_CONSTRUCT_ONLY`)
    /// which are not explicitly specified are set to their default values. Any
    /// private data for the object is guaranteed to be initialized with zeros, as
    /// per `gobject.typeCreateInstance`.
    ///
    /// Note that in C, small integer types in variable argument lists are promoted
    /// up to `gint` or `guint` as appropriate, and read back accordingly. `gint` is
    /// 32 bits on every platform on which GLib is currently supported. This means that
    /// you can use C expressions of type `gint` with `gobject.Object.new` and properties of
    /// type `gint` or `guint` or smaller. Specifically, you can use integer literals
    /// with these property types.
    ///
    /// When using property types of `gint64` or `guint64`, you must ensure that the
    /// value that you provide is 64 bit. This means that you should use a cast or
    /// make use of the `G_GINT64_CONSTANT` or `G_GUINT64_CONSTANT` macros.
    ///
    /// Similarly, `gfloat` is promoted to `gdouble`, so you must ensure that the value
    /// you provide is a `gdouble`, even for a property of type `gfloat`.
    ///
    /// Since GLib 2.72, all `GObjects` are guaranteed to be aligned to at least the
    /// alignment of the largest basic GLib type (typically this is `guint64` or
    /// `gdouble`). If you need larger alignment for an element in a `gobject.Object`, you
    /// should allocate it on the heap (aligned), or arrange for your `gobject.Object` to be
    /// appropriately padded.
    extern fn g_object_new(p_object_type: usize, p_first_property_name: [*:0]const u8, ...) *gobject.Object;
    pub const new = g_object_new;

    /// Creates a new instance of a `gobject.Object` subtype and sets its properties.
    ///
    /// Construction parameters (see `G_PARAM_CONSTRUCT`, `G_PARAM_CONSTRUCT_ONLY`)
    /// which are not explicitly specified are set to their default values.
    extern fn g_object_new_valist(p_object_type: usize, p_first_property_name: [*:0]const u8, p_var_args: std.builtin.VaList) *gobject.Object;
    pub const newValist = g_object_new_valist;

    /// Creates a new instance of a `gobject.Object` subtype and sets its properties using
    /// the provided arrays. Both arrays must have exactly `n_properties` elements,
    /// and the names and values correspond by index.
    ///
    /// Construction parameters (see `G_PARAM_CONSTRUCT`, `G_PARAM_CONSTRUCT_ONLY`)
    /// which are not explicitly specified are set to their default values.
    extern fn g_object_new_with_properties(p_object_type: usize, p_n_properties: c_uint, p_names: [*][*:0]const u8, p_values: [*]const gobject.Value) *gobject.Object;
    pub const newWithProperties = g_object_new_with_properties;

    /// Creates a new instance of a `gobject.Object` subtype and sets its properties.
    ///
    /// Construction parameters (see `G_PARAM_CONSTRUCT`, `G_PARAM_CONSTRUCT_ONLY`)
    /// which are not explicitly specified are set to their default values.
    extern fn g_object_newv(p_object_type: usize, p_n_parameters: c_uint, p_parameters: [*]gobject.Parameter) *gobject.Object;
    pub const newv = g_object_newv;

    /// Increases the reference count of the object by one and sets a
    /// callback to be called when all other references to the object are
    /// dropped, or when this is already the last reference to the object
    /// and another reference is established.
    ///
    /// This functionality is intended for binding `object` to a proxy
    /// object managed by another memory manager. This is done with two
    /// paired references: the strong reference added by
    /// `gobject.Object.addToggleRef` and a reverse reference to the proxy
    /// object which is either a strong reference or weak reference.
    ///
    /// The setup is that when there are no other references to `object`,
    /// only a weak reference is held in the reverse direction from `object`
    /// to the proxy object, but when there are other references held to
    /// `object`, a strong reference is held. The `notify` callback is called
    /// when the reference from `object` to the proxy object should be
    /// "toggled" from strong to weak (`is_last_ref` true) or weak to strong
    /// (`is_last_ref` false).
    ///
    /// Since a (normal) reference must be held to the object before
    /// calling `gobject.Object.addToggleRef`, the initial state of the reverse
    /// link is always strong.
    ///
    /// Multiple toggle references may be added to the same gobject,
    /// however if there are multiple toggle references to an object, none
    /// of them will ever be notified until all but one are removed.  For
    /// this reason, you should only ever use a toggle reference if there
    /// is important state in the proxy object.
    ///
    /// Note that if you unref the object on another thread, then `notify` might
    /// still be invoked after `gobject.Object.removeToggleRef`, and the object argument
    /// might be a dangling pointer. If the object is destroyed on other threads,
    /// you must take care of that yourself.
    ///
    /// A `gobject.Object.addToggleRef` must be released with `gobject.Object.removeToggleRef`.
    extern fn g_object_add_toggle_ref(p_object: *Object, p_notify: gobject.ToggleNotify, p_data: ?*anyopaque) void;
    pub const addToggleRef = g_object_add_toggle_ref;

    /// Adds a weak reference from weak_pointer to `object` to indicate that
    /// the pointer located at `weak_pointer_location` is only valid during
    /// the lifetime of `object`. When the `object` is finalized,
    /// `weak_pointer` will be set to `NULL`.
    ///
    /// Note that as with `gobject.Object.weakRef`, the weak references created by
    /// this method are not thread-safe: they cannot safely be used in one
    /// thread if the object's last `gobject.Object.unref` might happen in another
    /// thread. Use `gobject.WeakRef` if thread-safety is required.
    extern fn g_object_add_weak_pointer(p_object: *Object, p_weak_pointer_location: *anyopaque) void;
    pub const addWeakPointer = g_object_add_weak_pointer;

    /// Creates a binding between `source_property` on `source` and `target_property`
    /// on `target`.
    ///
    /// Whenever the `source_property` is changed the `target_property` is
    /// updated using the same value. For instance:
    ///
    /// ```
    ///   g_object_bind_property (action, "active", widget, "sensitive", 0);
    /// ```
    ///
    /// Will result in the "sensitive" property of the widget `gobject.Object` instance to be
    /// updated with the same value of the "active" property of the action `gobject.Object`
    /// instance.
    ///
    /// If `flags` contains `G_BINDING_BIDIRECTIONAL` then the binding will be mutual:
    /// if `target_property` on `target` changes then the `source_property` on `source`
    /// will be updated as well.
    ///
    /// The binding will automatically be removed when either the `source` or the
    /// `target` instances are finalized. To remove the binding without affecting the
    /// `source` and the `target` you can just call `gobject.Object.unref` on the returned
    /// `gobject.Binding` instance.
    ///
    /// Removing the binding by calling `gobject.Object.unref` on it must only be done if
    /// the binding, `source` and `target` are only used from a single thread and it
    /// is clear that both `source` and `target` outlive the binding. Especially it
    /// is not safe to rely on this if the binding, `source` or `target` can be
    /// finalized from different threads. Keep another reference to the binding and
    /// use `gobject.Binding.unbind` instead to be on the safe side.
    ///
    /// A `gobject.Object` can have multiple bindings.
    extern fn g_object_bind_property(p_source: *Object, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags) *gobject.Binding;
    pub const bindProperty = g_object_bind_property;

    /// Complete version of `gobject.Object.bindProperty`.
    ///
    /// Creates a binding between `source_property` on `source` and `target_property`
    /// on `target`, allowing you to set the transformation functions to be used by
    /// the binding.
    ///
    /// If `flags` contains `G_BINDING_BIDIRECTIONAL` then the binding will be mutual:
    /// if `target_property` on `target` changes then the `source_property` on `source`
    /// will be updated as well. The `transform_from` function is only used in case
    /// of bidirectional bindings, otherwise it will be ignored
    ///
    /// The binding will automatically be removed when either the `source` or the
    /// `target` instances are finalized. This will release the reference that is
    /// being held on the `gobject.Binding` instance; if you want to hold on to the
    /// `gobject.Binding` instance, you will need to hold a reference to it.
    ///
    /// To remove the binding, call `gobject.Binding.unbind`.
    ///
    /// A `gobject.Object` can have multiple bindings.
    ///
    /// The same `user_data` parameter will be used for both `transform_to`
    /// and `transform_from` transformation functions; the `notify` function will
    /// be called once, when the binding is removed. If you need different data
    /// for each transformation function, please use
    /// `gobject.Object.bindPropertyWithClosures` instead.
    extern fn g_object_bind_property_full(p_source: *Object, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags, p_transform_to: ?gobject.BindingTransformFunc, p_transform_from: ?gobject.BindingTransformFunc, p_user_data: ?*anyopaque, p_notify: ?glib.DestroyNotify) *gobject.Binding;
    pub const bindPropertyFull = g_object_bind_property_full;

    /// Creates a binding between `source_property` on `source` and `target_property`
    /// on `target`, allowing you to set the transformation functions to be used by
    /// the binding.
    ///
    /// This function is the language bindings friendly version of
    /// `gobject.Object.bindPropertyFull`, using `GClosures` instead of
    /// function pointers.
    extern fn g_object_bind_property_with_closures(p_source: *Object, p_source_property: [*:0]const u8, p_target: *gobject.Object, p_target_property: [*:0]const u8, p_flags: gobject.BindingFlags, p_transform_to: *gobject.Closure, p_transform_from: *gobject.Closure) *gobject.Binding;
    pub const bindPropertyWithClosures = g_object_bind_property_with_closures;

    /// A convenience function to connect multiple signals at once.
    ///
    /// The signal specs expected by this function have the form
    /// `modifier::signal_name`, where `modifier` can be one of the
    /// following:
    ///
    /// - `signal`: equivalent to `g_signal_connect_data (..., NULL, G_CONNECT_DEFAULT)`
    /// - `object-signal`, `object_signal`: equivalent to `g_signal_connect_object (..., G_CONNECT_DEFAULT)`
    /// - `swapped-signal`, `swapped_signal`: equivalent to `g_signal_connect_data (..., NULL, G_CONNECT_SWAPPED)`
    /// - `swapped_object_signal`, `swapped-object-signal`: equivalent to `g_signal_connect_object (..., G_CONNECT_SWAPPED)`
    /// - `signal_after`, `signal-after`: equivalent to `g_signal_connect_data (..., NULL, G_CONNECT_AFTER)`
    /// - `object_signal_after`, `object-signal-after`: equivalent to `g_signal_connect_object (..., G_CONNECT_AFTER)`
    /// - `swapped_signal_after`, `swapped-signal-after`: equivalent to `g_signal_connect_data (..., NULL, G_CONNECT_SWAPPED | G_CONNECT_AFTER)`
    /// - `swapped_object_signal_after`, `swapped-object-signal-after`: equivalent to `g_signal_connect_object (..., G_CONNECT_SWAPPED | G_CONNECT_AFTER)`
    ///
    /// ```c
    /// menu->toplevel = g_object_connect (g_object_new (GTK_TYPE_WINDOW,
    ///                                                  "type", GTK_WINDOW_POPUP,
    ///                                                  "child", menu,
    ///                                                  NULL),
    ///                                    "signal::event", gtk_menu_window_event, menu,
    ///                                    "signal::size_request", gtk_menu_window_size_request, menu,
    ///                                    "signal::destroy", gtk_widget_destroyed, &menu->toplevel,
    ///                                    NULL);
    /// ```
    extern fn g_object_connect(p_object: *Object, p_signal_spec: [*:0]const u8, ...) *gobject.Object;
    pub const connect = g_object_connect;

    /// A convenience function to disconnect multiple signals at once.
    ///
    /// The signal specs expected by this function have the form
    /// "any_signal", which means to disconnect any signal with matching
    /// callback and data, or "any_signal::signal_name", which only
    /// disconnects the signal named "signal_name".
    extern fn g_object_disconnect(p_object: *Object, p_signal_spec: [*:0]const u8, ...) void;
    pub const disconnect = g_object_disconnect;

    /// This is a variant of `gobject.Object.getData` which returns
    /// a 'duplicate' of the value. `dup_func` defines the
    /// meaning of 'duplicate' in this context, it could e.g.
    /// take a reference on a ref-counted object.
    ///
    /// If the `key` is not set on the object then `dup_func`
    /// will be called with a `NULL` argument.
    ///
    /// Note that `dup_func` is called while user data of `object`
    /// is locked.
    ///
    /// This function can be useful to avoid races when multiple
    /// threads are using object data on the same key on the same
    /// object.
    extern fn g_object_dup_data(p_object: *Object, p_key: [*:0]const u8, p_dup_func: ?glib.DuplicateFunc, p_user_data: ?*anyopaque) ?*anyopaque;
    pub const dupData = g_object_dup_data;

    /// This is a variant of `gobject.Object.getQdata` which returns
    /// a 'duplicate' of the value. `dup_func` defines the
    /// meaning of 'duplicate' in this context, it could e.g.
    /// take a reference on a ref-counted object.
    ///
    /// If the `quark` is not set on the object then `dup_func`
    /// will be called with a `NULL` argument.
    ///
    /// Note that `dup_func` is called while user data of `object`
    /// is locked.
    ///
    /// This function can be useful to avoid races when multiple
    /// threads are using object data on the same key on the same
    /// object.
    extern fn g_object_dup_qdata(p_object: *Object, p_quark: glib.Quark, p_dup_func: ?glib.DuplicateFunc, p_user_data: ?*anyopaque) ?*anyopaque;
    pub const dupQdata = g_object_dup_qdata;

    /// This function is intended for `gobject.Object` implementations to re-enforce
    /// a [floating][floating-ref] object reference. Doing this is seldom
    /// required: all `GInitiallyUnowneds` are created with a floating reference
    /// which usually just needs to be sunken by calling `gobject.Object.refSink`.
    extern fn g_object_force_floating(p_object: *Object) void;
    pub const forceFloating = g_object_force_floating;

    /// Increases the freeze count on `object`. If the freeze count is
    /// non-zero, the emission of "notify" signals on `object` is
    /// stopped. The signals are queued until the freeze count is decreased
    /// to zero. Duplicate notifications are squashed so that at most one
    /// `gobject.Object.signals.notify` signal is emitted for each property modified while the
    /// object is frozen.
    ///
    /// This is necessary for accessors that modify multiple properties to prevent
    /// premature notification while the object is still being modified.
    extern fn g_object_freeze_notify(p_object: *Object) void;
    pub const freezeNotify = g_object_freeze_notify;

    /// Gets properties of an object.
    ///
    /// In general, a copy is made of the property contents and the caller
    /// is responsible for freeing the memory in the appropriate manner for
    /// the type, for instance by calling `glib.free` or `gobject.Object.unref`.
    ///
    /// Here is an example of using `gobject.Object.get` to get the contents
    /// of three properties: an integer, a string and an object:
    /// ```
    ///  gint intval;
    ///  guint64 uint64val;
    ///  gchar *strval;
    ///  GObject *objval;
    ///
    ///  g_object_get (my_object,
    ///                "int-property", &intval,
    ///                "uint64-property", &uint64val,
    ///                "str-property", &strval,
    ///                "obj-property", &objval,
    ///                NULL);
    ///
    ///  // Do something with intval, uint64val, strval, objval
    ///
    ///  g_free (strval);
    ///  g_object_unref (objval);
    /// ```
    extern fn g_object_get(p_object: *Object, p_first_property_name: [*:0]const u8, ...) void;
    pub const get = g_object_get;

    /// Gets a named field from the objects table of associations (see `gobject.Object.setData`).
    extern fn g_object_get_data(p_object: *Object, p_key: [*:0]const u8) ?*anyopaque;
    pub const getData = g_object_get_data;

    /// Gets a property of an object.
    ///
    /// The `value` can be:
    ///
    ///  - an empty `gobject.Value` initialized by `G_VALUE_INIT`, which will be
    ///    automatically initialized with the expected type of the property
    ///    (since GLib 2.60)
    ///  - a `gobject.Value` initialized with the expected type of the property
    ///  - a `gobject.Value` initialized with a type to which the expected type
    ///    of the property can be transformed
    ///
    /// In general, a copy is made of the property contents and the caller is
    /// responsible for freeing the memory by calling `gobject.Value.unset`.
    ///
    /// Note that `gobject.Object.getProperty` is really intended for language
    /// bindings, `gobject.Object.get` is much more convenient for C programming.
    extern fn g_object_get_property(p_object: *Object, p_property_name: [*:0]const u8, p_value: *gobject.Value) void;
    pub const getProperty = g_object_get_property;

    /// This function gets back user data pointers stored via
    /// `gobject.Object.setQdata`.
    extern fn g_object_get_qdata(p_object: *Object, p_quark: glib.Quark) ?*anyopaque;
    pub const getQdata = g_object_get_qdata;

    /// Gets properties of an object.
    ///
    /// In general, a copy is made of the property contents and the caller
    /// is responsible for freeing the memory in the appropriate manner for
    /// the type, for instance by calling `glib.free` or `gobject.Object.unref`.
    ///
    /// See `gobject.Object.get`.
    extern fn g_object_get_valist(p_object: *Object, p_first_property_name: [*:0]const u8, p_var_args: std.builtin.VaList) void;
    pub const getValist = g_object_get_valist;

    /// Gets `n_properties` properties for an `object`.
    /// Obtained properties will be set to `values`. All properties must be valid.
    /// Warnings will be emitted and undefined behaviour may result if invalid
    /// properties are passed in.
    extern fn g_object_getv(p_object: *Object, p_n_properties: c_uint, p_names: [*][*:0]const u8, p_values: [*]gobject.Value) void;
    pub const getv = g_object_getv;

    /// Checks whether `object` has a [floating][floating-ref] reference.
    extern fn g_object_is_floating(p_object: *Object) c_int;
    pub const isFloating = g_object_is_floating;

    /// Emits a "notify" signal for the property `property_name` on `object`.
    ///
    /// When possible, eg. when signaling a property change from within the class
    /// that registered the property, you should use `gobject.Object.notifyByPspec`
    /// instead.
    ///
    /// Note that emission of the notify signal may be blocked with
    /// `gobject.Object.freezeNotify`. In this case, the signal emissions are queued
    /// and will be emitted (in reverse order) when `gobject.Object.thawNotify` is
    /// called.
    extern fn g_object_notify(p_object: *Object, p_property_name: [*:0]const u8) void;
    pub const notify = g_object_notify;

    /// Emits a "notify" signal for the property specified by `pspec` on `object`.
    ///
    /// This function omits the property name lookup, hence it is faster than
    /// `gobject.Object.notify`.
    ///
    /// One way to avoid using `gobject.Object.notify` from within the
    /// class that registered the properties, and using `gobject.Object.notifyByPspec`
    /// instead, is to store the GParamSpec used with
    /// `gobject.ObjectClass.installProperty` inside a static array, e.g.:
    ///
    /// ```
    ///   typedef enum
    ///   {
    ///     PROP_FOO = 1,
    ///     PROP_LAST
    ///   } MyObjectProperty;
    ///
    ///   static GParamSpec *properties[PROP_LAST];
    ///
    ///   static void
    ///   my_object_class_init (MyObjectClass *klass)
    ///   {
    ///     properties[PROP_FOO] = g_param_spec_int ("foo", NULL, NULL,
    ///                                              0, 100,
    ///                                              50,
    ///                                              G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);
    ///     g_object_class_install_property (gobject_class,
    ///                                      PROP_FOO,
    ///                                      properties[PROP_FOO]);
    ///   }
    /// ```
    ///
    /// and then notify a change on the "foo" property with:
    ///
    /// ```
    ///   g_object_notify_by_pspec (self, properties[PROP_FOO]);
    /// ```
    extern fn g_object_notify_by_pspec(p_object: *Object, p_pspec: *gobject.ParamSpec) void;
    pub const notifyByPspec = g_object_notify_by_pspec;

    /// Increases the reference count of `object`.
    ///
    /// Since GLib 2.56, if `GLIB_VERSION_MAX_ALLOWED` is 2.56 or greater, the type
    /// of `object` will be propagated to the return type (using the GCC `typeof`
    /// extension), so any casting the caller needs to do on the return type must be
    /// explicit.
    extern fn g_object_ref(p_object: *Object) *gobject.Object;
    pub const ref = g_object_ref;

    /// Increase the reference count of `object`, and possibly remove the
    /// [floating][floating-ref] reference, if `object` has a floating reference.
    ///
    /// In other words, if the object is floating, then this call "assumes
    /// ownership" of the floating reference, converting it to a normal
    /// reference by clearing the floating flag while leaving the reference
    /// count unchanged.  If the object is not floating, then this call
    /// adds a new normal reference increasing the reference count by one.
    ///
    /// Since GLib 2.56, the type of `object` will be propagated to the return type
    /// under the same conditions as for `gobject.Object.ref`.
    extern fn g_object_ref_sink(p_object: *Object) *gobject.Object;
    pub const refSink = g_object_ref_sink;

    /// Removes a reference added with `gobject.Object.addToggleRef`. The
    /// reference count of the object is decreased by one.
    ///
    /// Note that if you unref the object on another thread, then `notify` might
    /// still be invoked after `gobject.Object.removeToggleRef`, and the object argument
    /// might be a dangling pointer. If the object is destroyed on other threads,
    /// you must take care of that yourself.
    extern fn g_object_remove_toggle_ref(p_object: *Object, p_notify: gobject.ToggleNotify, p_data: ?*anyopaque) void;
    pub const removeToggleRef = g_object_remove_toggle_ref;

    /// Removes a weak reference from `object` that was previously added
    /// using `gobject.Object.addWeakPointer`. The `weak_pointer_location` has
    /// to match the one used with `gobject.Object.addWeakPointer`.
    extern fn g_object_remove_weak_pointer(p_object: *Object, p_weak_pointer_location: *anyopaque) void;
    pub const removeWeakPointer = g_object_remove_weak_pointer;

    /// Compares the user data for the key `key` on `object` with
    /// `oldval`, and if they are the same, replaces `oldval` with
    /// `newval`.
    ///
    /// This is like a typical atomic compare-and-exchange
    /// operation, for user data on an object.
    ///
    /// If the previous value was replaced then ownership of the
    /// old value (`oldval`) is passed to the caller, including
    /// the registered destroy notify for it (passed out in `old_destroy`).
    /// It’s up to the caller to free this as needed, which may
    /// or may not include using `old_destroy` as sometimes replacement
    /// should not destroy the object in the normal way.
    ///
    /// See `gobject.Object.setData` for guidance on using a small, bounded set of values
    /// for `key`.
    extern fn g_object_replace_data(p_object: *Object, p_key: [*:0]const u8, p_oldval: ?*anyopaque, p_newval: ?*anyopaque, p_destroy: ?glib.DestroyNotify, p_old_destroy: ?*glib.DestroyNotify) c_int;
    pub const replaceData = g_object_replace_data;

    /// Compares the user data for the key `quark` on `object` with
    /// `oldval`, and if they are the same, replaces `oldval` with
    /// `newval`.
    ///
    /// This is like a typical atomic compare-and-exchange
    /// operation, for user data on an object.
    ///
    /// If the previous value was replaced then ownership of the
    /// old value (`oldval`) is passed to the caller, including
    /// the registered destroy notify for it (passed out in `old_destroy`).
    /// It’s up to the caller to free this as needed, which may
    /// or may not include using `old_destroy` as sometimes replacement
    /// should not destroy the object in the normal way.
    extern fn g_object_replace_qdata(p_object: *Object, p_quark: glib.Quark, p_oldval: ?*anyopaque, p_newval: ?*anyopaque, p_destroy: ?glib.DestroyNotify, p_old_destroy: ?*glib.DestroyNotify) c_int;
    pub const replaceQdata = g_object_replace_qdata;

    /// Releases all references to other objects. This can be used to break
    /// reference cycles.
    ///
    /// This function should only be called from object system implementations.
    extern fn g_object_run_dispose(p_object: *Object) void;
    pub const runDispose = g_object_run_dispose;

    /// Sets properties on an object.
    ///
    /// The same caveats about passing integer literals as varargs apply as with
    /// `gobject.Object.new`. In particular, any integer literals set as the values for
    /// properties of type `gint64` or `guint64` must be 64 bits wide, using the
    /// `G_GINT64_CONSTANT` or `G_GUINT64_CONSTANT` macros.
    ///
    /// Note that the "notify" signals are queued and only emitted (in
    /// reverse order) after all properties have been set. See
    /// `gobject.Object.freezeNotify`.
    extern fn g_object_set(p_object: *Object, p_first_property_name: [*:0]const u8, ...) void;
    pub const set = g_object_set;

    /// Each object carries around a table of associations from
    /// strings to pointers.  This function lets you set an association.
    ///
    /// If the object already had an association with that name,
    /// the old association will be destroyed.
    ///
    /// Internally, the `key` is converted to a `glib.Quark` using `glib.quarkFromString`.
    /// This means a copy of `key` is kept permanently (even after `object` has been
    /// finalized) — so it is recommended to only use a small, bounded set of values
    /// for `key` in your program, to avoid the `glib.Quark` storage growing unbounded.
    extern fn g_object_set_data(p_object: *Object, p_key: [*:0]const u8, p_data: ?*anyopaque) void;
    pub const setData = g_object_set_data;

    /// Like `gobject.Object.setData` except it adds notification
    /// for when the association is destroyed, either by setting it
    /// to a different value or when the object is destroyed.
    ///
    /// Note that the `destroy` callback is not called if `data` is `NULL`.
    extern fn g_object_set_data_full(p_object: *Object, p_key: [*:0]const u8, p_data: ?*anyopaque, p_destroy: ?glib.DestroyNotify) void;
    pub const setDataFull = g_object_set_data_full;

    /// Sets a property on an object.
    extern fn g_object_set_property(p_object: *Object, p_property_name: [*:0]const u8, p_value: *const gobject.Value) void;
    pub const setProperty = g_object_set_property;

    /// This sets an opaque, named pointer on an object.
    /// The name is specified through a `glib.Quark` (retrieved e.g. via
    /// `glib.quarkFromStaticString`), and the pointer
    /// can be gotten back from the `object` with `gobject.Object.getQdata`
    /// until the `object` is finalized.
    /// Setting a previously set user data pointer, overrides (frees)
    /// the old pointer set, using `NULL` as pointer essentially
    /// removes the data stored.
    extern fn g_object_set_qdata(p_object: *Object, p_quark: glib.Quark, p_data: ?*anyopaque) void;
    pub const setQdata = g_object_set_qdata;

    /// This function works like `gobject.Object.setQdata`, but in addition,
    /// a void (*destroy) (gpointer) function may be specified which is
    /// called with `data` as argument when the `object` is finalized, or
    /// the data is being overwritten by a call to `gobject.Object.setQdata`
    /// with the same `quark`.
    extern fn g_object_set_qdata_full(p_object: *Object, p_quark: glib.Quark, p_data: ?*anyopaque, p_destroy: ?glib.DestroyNotify) void;
    pub const setQdataFull = g_object_set_qdata_full;

    /// Sets properties on an object.
    extern fn g_object_set_valist(p_object: *Object, p_first_property_name: [*:0]const u8, p_var_args: std.builtin.VaList) void;
    pub const setValist = g_object_set_valist;

    /// Sets `n_properties` properties for an `object`.
    /// Properties to be set will be taken from `values`. All properties must be
    /// valid. Warnings will be emitted and undefined behaviour may result if invalid
    /// properties are passed in.
    extern fn g_object_setv(p_object: *Object, p_n_properties: c_uint, p_names: [*][*:0]const u8, p_values: [*]const gobject.Value) void;
    pub const setv = g_object_setv;

    /// Remove a specified datum from the object's data associations,
    /// without invoking the association's destroy handler.
    extern fn g_object_steal_data(p_object: *Object, p_key: [*:0]const u8) ?*anyopaque;
    pub const stealData = g_object_steal_data;

    /// This function gets back user data pointers stored via
    /// `gobject.Object.setQdata` and removes the `data` from object
    /// without invoking its `destroy` function (if any was
    /// set).
    /// Usually, calling this function is only required to update
    /// user data pointers with a destroy notifier, for example:
    /// ```
    /// void
    /// object_add_to_user_list (GObject     *object,
    ///                          const gchar *new_string)
    /// {
    ///   // the quark, naming the object data
    ///   GQuark quark_string_list = g_quark_from_static_string ("my-string-list");
    ///   // retrieve the old string list
    ///   GList *list = g_object_steal_qdata (object, quark_string_list);
    ///
    ///   // prepend new string
    ///   list = g_list_prepend (list, g_strdup (new_string));
    ///   // this changed 'list', so we need to set it again
    ///   g_object_set_qdata_full (object, quark_string_list, list, free_string_list);
    /// }
    /// static void
    /// free_string_list (gpointer data)
    /// {
    ///   GList *node, *list = data;
    ///
    ///   for (node = list; node; node = node->next)
    ///     g_free (node->data);
    ///   g_list_free (list);
    /// }
    /// ```
    /// Using `gobject.Object.getQdata` in the above example, instead of
    /// `gobject.Object.stealQdata` would have left the destroy function set,
    /// and thus the partial string list would have been freed upon
    /// `gobject.Object.setQdataFull`.
    extern fn g_object_steal_qdata(p_object: *Object, p_quark: glib.Quark) ?*anyopaque;
    pub const stealQdata = g_object_steal_qdata;

    /// If `object` is floating, sink it.  Otherwise, do nothing.
    ///
    /// In other words, this function will convert a floating reference (if
    /// present) into a full reference.
    ///
    /// Typically you want to use `gobject.Object.refSink` in order to
    /// automatically do the correct thing with respect to floating or
    /// non-floating references, but there is one specific scenario where
    /// this function is helpful.
    ///
    /// The situation where this function is helpful is when creating an API
    /// that allows the user to provide a callback function that returns a
    /// GObject. We certainly want to allow the user the flexibility to
    /// return a non-floating reference from this callback (for the case
    /// where the object that is being returned already exists).
    ///
    /// At the same time, the API style of some popular GObject-based
    /// libraries (such as Gtk) make it likely that for newly-created GObject
    /// instances, the user can be saved some typing if they are allowed to
    /// return a floating reference.
    ///
    /// Using this function on the return value of the user's callback allows
    /// the user to do whichever is more convenient for them. The caller will
    /// always receives exactly one full reference to the value: either the
    /// one that was returned in the first place, or a floating reference
    /// that has been converted to a full reference.
    ///
    /// This function has an odd interaction when combined with
    /// `gobject.Object.refSink` running at the same time in another thread on
    /// the same `gobject.Object` instance. If `gobject.Object.refSink` runs first then
    /// the result will be that the floating reference is converted to a hard
    /// reference. If `gobject.Object.takeRef` runs first then the result will be
    /// that the floating reference is converted to a hard reference and an
    /// additional reference on top of that one is added. It is best to avoid
    /// this situation.
    extern fn g_object_take_ref(p_object: *Object) *gobject.Object;
    pub const takeRef = g_object_take_ref;

    /// Reverts the effect of a previous call to
    /// `gobject.Object.freezeNotify`. The freeze count is decreased on `object`
    /// and when it reaches zero, queued "notify" signals are emitted.
    ///
    /// Duplicate notifications for each property are squashed so that at most one
    /// `gobject.Object.signals.notify` signal is emitted for each property, in the reverse order
    /// in which they have been queued.
    ///
    /// It is an error to call this function when the freeze count is zero.
    extern fn g_object_thaw_notify(p_object: *Object) void;
    pub const thawNotify = g_object_thaw_notify;

    /// Decreases the reference count of `object`. When its reference count
    /// drops to 0, the object is finalized (i.e. its memory is freed).
    ///
    /// If the pointer to the `gobject.Object` may be reused in future (for example, if it is
    /// an instance variable of another object), it is recommended to clear the
    /// pointer to `NULL` rather than retain a dangling pointer to a potentially
    /// invalid `gobject.Object` instance. Use `gobject.clearObject` for this.
    extern fn g_object_unref(p_object: *Object) void;
    pub const unref = g_object_unref;

    /// This function essentially limits the life time of the `closure` to
    /// the life time of the object. That is, when the object is finalized,
    /// the `closure` is invalidated by calling `gobject.Closure.invalidate` on
    /// it, in order to prevent invocations of the closure with a finalized
    /// (nonexisting) object. Also, `gobject.Object.ref` and `gobject.Object.unref` are
    /// added as marshal guards to the `closure`, to ensure that an extra
    /// reference count is held on `object` during invocation of the
    /// `closure`.  Usually, this function will be called on closures that
    /// use this `object` as closure data.
    extern fn g_object_watch_closure(p_object: *Object, p_closure: *gobject.Closure) void;
    pub const watchClosure = g_object_watch_closure;

    /// Adds a weak reference callback to an object. Weak references are
    /// used for notification when an object is disposed. They are called
    /// "weak references" because they allow you to safely hold a pointer
    /// to an object without calling `gobject.Object.ref` (`gobject.Object.ref` adds a
    /// strong reference, that is, forces the object to stay alive).
    ///
    /// Note that the weak references created by this method are not
    /// thread-safe: they cannot safely be used in one thread if the
    /// object's last `gobject.Object.unref` might happen in another thread.
    /// Use `gobject.WeakRef` if thread-safety is required.
    extern fn g_object_weak_ref(p_object: *Object, p_notify: gobject.WeakNotify, p_data: ?*anyopaque) void;
    pub const weakRef = g_object_weak_ref;

    /// Removes a weak reference callback to an object.
    extern fn g_object_weak_unref(p_object: *Object, p_notify: gobject.WeakNotify, p_data: ?*anyopaque) void;
    pub const weakUnref = g_object_weak_unref;

    extern fn g_object_get_type() usize;
    pub const getGObjectType = g_object_get_type;

    pub fn as(p_instance: *Object, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// `GParamSpec` encapsulates the metadata required to specify parameters, such as `GObject` properties.
///
/// ## Parameter names
///
/// A property name consists of one or more segments consisting of ASCII letters
/// and digits, separated by either the `-` or `_` character. The first
/// character of a property name must be a letter. These are the same rules as
/// for signal naming (see `gobject.signalNew`).
///
/// When creating and looking up a `GParamSpec`, either separator can be
/// used, but they cannot be mixed. Using `-` is considerably more
/// efficient, and is the ‘canonical form’. Using `_` is discouraged.
pub const ParamSpec = extern struct {
    pub const Parent = gobject.TypeInstance;
    pub const Implements = [_]type{};
    pub const Class = gobject.ParamSpecClass;
    /// private `GTypeInstance` portion
    f_g_type_instance: gobject.TypeInstance,
    /// name of this parameter: always an interned string
    f_name: ?[*:0]const u8,
    /// `GParamFlags` flags for this parameter
    f_flags: gobject.ParamFlags,
    /// the `GValue` type for this parameter
    f_value_type: usize,
    /// `GType` type that uses (introduces) this parameter
    f_owner_type: usize,
    f__nick: ?[*:0]u8,
    f__blurb: ?[*:0]u8,
    f_qdata: ?*glib.Data,
    f_ref_count: c_uint,
    f_param_id: c_uint,

    pub const virtual_methods = struct {
        /// The instance finalization function (optional), should chain
        ///  up to the finalize method of the parent class.
        pub const finalize = struct {
            pub fn call(p_class: anytype, p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(ParamSpec.Class, p_class).f_finalize.?(gobject.ext.as(ParamSpec, p_pspec));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(ParamSpec.Class, p_class).f_finalize = @ptrCast(p_implementation);
            }
        };

        /// Checks if contents of `value` comply with the specifications
        ///   set out by this type, without modifying the value. This vfunc is optional.
        ///   If it isn't set, GObject will use `value_validate`. Since 2.74
        pub const value_is_valid = struct {
            pub fn call(p_class: anytype, p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *const gobject.Value) c_int {
                return gobject.ext.as(ParamSpec.Class, p_class).f_value_is_valid.?(gobject.ext.as(ParamSpec, p_pspec), p_value);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *const gobject.Value) callconv(.c) c_int) void {
                gobject.ext.as(ParamSpec.Class, p_class).f_value_is_valid = @ptrCast(p_implementation);
            }
        };

        /// Resets a `value` to the default value for this type
        ///  (recommended, the default is `gobject.Value.reset`), see
        ///  `gobject.paramValueSetDefault`.
        pub const value_set_default = struct {
            pub fn call(p_class: anytype, p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *gobject.Value) void {
                return gobject.ext.as(ParamSpec.Class, p_class).f_value_set_default.?(gobject.ext.as(ParamSpec, p_pspec), p_value);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *gobject.Value) callconv(.c) void) void {
                gobject.ext.as(ParamSpec.Class, p_class).f_value_set_default = @ptrCast(p_implementation);
            }
        };

        /// Ensures that the contents of `value` comply with the
        ///  specifications set out by this type (optional), see
        ///  `gobject.paramValueValidate`.
        pub const value_validate = struct {
            pub fn call(p_class: anytype, p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *gobject.Value) c_int {
                return gobject.ext.as(ParamSpec.Class, p_class).f_value_validate.?(gobject.ext.as(ParamSpec, p_pspec), p_value);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value: *gobject.Value) callconv(.c) c_int) void {
                gobject.ext.as(ParamSpec.Class, p_class).f_value_validate = @ptrCast(p_implementation);
            }
        };

        /// Compares `value1` with `value2` according to this type
        ///  (recommended, the default is `memcmp`), see `gobject.paramValuesCmp`.
        pub const values_cmp = struct {
            pub fn call(p_class: anytype, p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value1: *const gobject.Value, p_value2: *const gobject.Value) c_int {
                return gobject.ext.as(ParamSpec.Class, p_class).f_values_cmp.?(gobject.ext.as(ParamSpec, p_pspec), p_value1, p_value2);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_pspec: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_value1: *const gobject.Value, p_value2: *const gobject.Value) callconv(.c) c_int) void {
                gobject.ext.as(ParamSpec.Class, p_class).f_values_cmp = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    /// Creates a new `gobject.ParamSpec` instance.
    ///
    /// See [canonical parameter names]`gobject.@"ParamSpec#parameter-names"`
    /// for details of the rules for `name`. Names which violate these rules lead
    /// to undefined behaviour.
    ///
    /// Beyond the name, `GParamSpecs` have two more descriptive strings, the
    /// `nick` and `blurb`, which may be used as a localized label and description.
    /// For GTK and related libraries these are considered deprecated and may be
    /// omitted, while for other libraries such as GStreamer and its plugins they
    /// are essential. When in doubt, follow the conventions used in the
    /// surrounding code and supporting libraries.
    extern fn g_param_spec_internal(p_param_type: usize, p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
    pub const internal = g_param_spec_internal;

    /// Validate a property name for a `gobject.ParamSpec`. This can be useful for
    /// dynamically-generated properties which need to be validated at run-time
    /// before actually trying to create them.
    ///
    /// See [canonical parameter names]`gobject.@"ParamSpec#parameter-names"`
    /// for details of the rules for valid names.
    extern fn g_param_spec_is_valid_name(p_name: [*:0]const u8) c_int;
    pub const isValidName = g_param_spec_is_valid_name;

    /// Get the short description of a `gobject.ParamSpec`.
    extern fn g_param_spec_get_blurb(p_pspec: *ParamSpec) ?[*:0]const u8;
    pub const getBlurb = g_param_spec_get_blurb;

    /// Gets the default value of `pspec` as a pointer to a `gobject.Value`.
    ///
    /// The `gobject.Value` will remain valid for the life of `pspec`.
    extern fn g_param_spec_get_default_value(p_pspec: *ParamSpec) *const gobject.Value;
    pub const getDefaultValue = g_param_spec_get_default_value;

    /// Get the name of a `gobject.ParamSpec`.
    ///
    /// The name is always an "interned" string (as per `glib.internString`).
    /// This allows for pointer-value comparisons.
    extern fn g_param_spec_get_name(p_pspec: *ParamSpec) [*:0]const u8;
    pub const getName = g_param_spec_get_name;

    /// Gets the GQuark for the name.
    extern fn g_param_spec_get_name_quark(p_pspec: *ParamSpec) glib.Quark;
    pub const getNameQuark = g_param_spec_get_name_quark;

    /// Get the nickname of a `gobject.ParamSpec`.
    extern fn g_param_spec_get_nick(p_pspec: *ParamSpec) [*:0]const u8;
    pub const getNick = g_param_spec_get_nick;

    /// Gets back user data pointers stored via `gobject.ParamSpec.setQdata`.
    extern fn g_param_spec_get_qdata(p_pspec: *ParamSpec, p_quark: glib.Quark) ?*anyopaque;
    pub const getQdata = g_param_spec_get_qdata;

    /// If the paramspec redirects operations to another paramspec,
    /// returns that paramspec. Redirect is used typically for
    /// providing a new implementation of a property in a derived
    /// type while preserving all the properties from the parent
    /// type. Redirection is established by creating a property
    /// of type `gobject.ParamSpecOverride`. See `gobject.ObjectClass.overrideProperty`
    /// for an example of the use of this capability.
    extern fn g_param_spec_get_redirect_target(p_pspec: *ParamSpec) ?*gobject.ParamSpec;
    pub const getRedirectTarget = g_param_spec_get_redirect_target;

    /// Increments the reference count of `pspec`.
    extern fn g_param_spec_ref(p_pspec: *ParamSpec) *gobject.ParamSpec;
    pub const ref = g_param_spec_ref;

    /// Convenience function to ref and sink a `gobject.ParamSpec`.
    extern fn g_param_spec_ref_sink(p_pspec: *ParamSpec) *gobject.ParamSpec;
    pub const refSink = g_param_spec_ref_sink;

    /// Sets an opaque, named pointer on a `gobject.ParamSpec`. The name is
    /// specified through a `glib.Quark` (retrieved e.g. via
    /// `glib.quarkFromStaticString`), and the pointer can be gotten back
    /// from the `pspec` with `gobject.ParamSpec.getQdata`.  Setting a
    /// previously set user data pointer, overrides (frees) the old pointer
    /// set, using `NULL` as pointer essentially removes the data stored.
    extern fn g_param_spec_set_qdata(p_pspec: *ParamSpec, p_quark: glib.Quark, p_data: ?*anyopaque) void;
    pub const setQdata = g_param_spec_set_qdata;

    /// This function works like `gobject.ParamSpec.setQdata`, but in addition,
    /// a `void (*destroy) (gpointer)` function may be
    /// specified which is called with `data` as argument when the `pspec` is
    /// finalized, or the data is being overwritten by a call to
    /// `gobject.ParamSpec.setQdata` with the same `quark`.
    extern fn g_param_spec_set_qdata_full(p_pspec: *ParamSpec, p_quark: glib.Quark, p_data: ?*anyopaque, p_destroy: ?glib.DestroyNotify) void;
    pub const setQdataFull = g_param_spec_set_qdata_full;

    /// The initial reference count of a newly created `gobject.ParamSpec` is 1,
    /// even though no one has explicitly called `gobject.ParamSpec.ref` on it
    /// yet. So the initial reference count is flagged as "floating", until
    /// someone calls `g_param_spec_ref (pspec); g_param_spec_sink
    /// (pspec);` in sequence on it, taking over the initial
    /// reference count (thus ending up with a `pspec` that has a reference
    /// count of 1 still, but is not flagged "floating" anymore).
    extern fn g_param_spec_sink(p_pspec: *ParamSpec) void;
    pub const sink = g_param_spec_sink;

    /// Gets back user data pointers stored via `gobject.ParamSpec.setQdata`
    /// and removes the `data` from `pspec` without invoking its `destroy`
    /// function (if any was set).  Usually, calling this function is only
    /// required to update user data pointers with a destroy notifier.
    extern fn g_param_spec_steal_qdata(p_pspec: *ParamSpec, p_quark: glib.Quark) ?*anyopaque;
    pub const stealQdata = g_param_spec_steal_qdata;

    /// Decrements the reference count of a `pspec`.
    extern fn g_param_spec_unref(p_pspec: *ParamSpec) void;
    pub const unref = g_param_spec_unref;

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpec, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for boolean properties.
pub const ParamSpecBoolean = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecBoolean;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// default value for the property specified
    f_default_value: c_int,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecBoolean, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for boxed properties.
pub const ParamSpecBoxed = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecBoxed;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecBoxed, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for character properties.
pub const ParamSpecChar = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecChar;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: i8,
    /// maximum value for the property specified
    f_maximum: i8,
    /// default value for the property specified
    f_default_value: i8,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecChar, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for double properties.
pub const ParamSpecDouble = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecDouble;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: f64,
    /// maximum value for the property specified
    f_maximum: f64,
    /// default value for the property specified
    f_default_value: f64,
    /// values closer than `epsilon` will be considered identical
    ///  by `gobject.paramValuesCmp`; the default value is 1e-90.
    f_epsilon: f64,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecDouble, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for enum
/// properties.
pub const ParamSpecEnum = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecEnum;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// the `gobject.EnumClass` for the enum
    f_enum_class: ?*gobject.EnumClass,
    /// default value for the property specified
    f_default_value: c_int,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecEnum, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for flags
/// properties.
pub const ParamSpecFlags = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecFlags;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// the `gobject.FlagsClass` for the flags
    f_flags_class: ?*gobject.FlagsClass,
    /// default value for the property specified
    f_default_value: c_uint,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecFlags, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for float properties.
pub const ParamSpecFloat = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecFloat;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: f32,
    /// maximum value for the property specified
    f_maximum: f32,
    /// default value for the property specified
    f_default_value: f32,
    /// values closer than `epsilon` will be considered identical
    ///  by `gobject.paramValuesCmp`; the default value is 1e-30.
    f_epsilon: f32,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecFloat, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for `gobject.Type` properties.
pub const ParamSpecGType = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecGType;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// a `gobject.Type` whose subtypes can occur as values
    f_is_a_type: usize,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecGType, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for integer properties.
pub const ParamSpecInt = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecInt;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: c_int,
    /// maximum value for the property specified
    f_maximum: c_int,
    /// default value for the property specified
    f_default_value: c_int,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecInt, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for 64bit integer properties.
pub const ParamSpecInt64 = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecInt64;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: i64,
    /// maximum value for the property specified
    f_maximum: i64,
    /// default value for the property specified
    f_default_value: i64,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecInt64, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for long integer properties.
pub const ParamSpecLong = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecLong;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: c_long,
    /// maximum value for the property specified
    f_maximum: c_long,
    /// default value for the property specified
    f_default_value: c_long,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecLong, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for object properties.
pub const ParamSpecObject = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecObject;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecObject, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that redirects operations to
/// other types of `gobject.ParamSpec`.
///
/// All operations other than getting or setting the value are redirected,
/// including accessing the nick and blurb, validating a value, and so
/// forth.
///
/// See `gobject.ParamSpec.getRedirectTarget` for retrieving the overridden
/// property. `gobject.ParamSpecOverride` is used in implementing
/// `gobject.ObjectClass.overrideProperty`, and will not be directly useful
/// unless you are implementing a new base type similar to GObject.
pub const ParamSpecOverride = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecOverride;
    };
    f_parent_instance: gobject.ParamSpec,
    f_overridden: ?*gobject.ParamSpec,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecOverride, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for `G_TYPE_PARAM`
/// properties.
pub const ParamSpecParam = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecParam;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecParam, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for pointer properties.
pub const ParamSpecPointer = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecPointer;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecPointer, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for string
/// properties.
pub const ParamSpecString = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecString;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// default value for the property specified
    f_default_value: ?[*:0]u8,
    /// a string containing the allowed values for the first byte
    f_cset_first: ?[*:0]u8,
    /// a string containing the allowed values for the subsequent bytes
    f_cset_nth: ?[*:0]u8,
    /// the replacement byte for bytes which don't match `cset_first` or `cset_nth`.
    f_substitutor: u8,
    bitfields0: packed struct(c_uint) {
        /// replace empty string by `NULL`
        f_null_fold_if_empty: u1,
        /// replace `NULL` strings by an empty string
        f_ensure_non_null: u1,
        _: u30,
    },

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecString, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for unsigned character properties.
pub const ParamSpecUChar = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecUChar;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: u8,
    /// maximum value for the property specified
    f_maximum: u8,
    /// default value for the property specified
    f_default_value: u8,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecUChar, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for unsigned integer properties.
pub const ParamSpecUInt = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecUInt;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: c_uint,
    /// maximum value for the property specified
    f_maximum: c_uint,
    /// default value for the property specified
    f_default_value: c_uint,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecUInt, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for unsigned 64bit integer properties.
pub const ParamSpecUInt64 = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecUInt64;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: u64,
    /// maximum value for the property specified
    f_maximum: u64,
    /// default value for the property specified
    f_default_value: u64,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecUInt64, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for unsigned long integer properties.
pub const ParamSpecULong = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecULong;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// minimum value for the property specified
    f_minimum: c_ulong,
    /// maximum value for the property specified
    f_maximum: c_ulong,
    /// default value for the property specified
    f_default_value: c_ulong,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecULong, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for unichar (unsigned integer) properties.
pub const ParamSpecUnichar = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecUnichar;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// default value for the property specified
    f_default_value: u32,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecUnichar, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for `gobject.ValueArray` properties.
pub const ParamSpecValueArray = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecValueArray;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// a `gobject.ParamSpec` describing the elements contained in arrays of this property, may be `NULL`
    f_element_spec: ?*gobject.ParamSpec,
    /// if greater than 0, arrays of this property will always have this many elements
    f_fixed_n_elements: c_uint,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecValueArray, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpec` derived structure that contains the meta data for `glib.Variant` properties.
///
/// When comparing values with `gobject.paramValuesCmp`, scalar values with the same
/// type will be compared with `glib.Variant.compare`. Other non-`NULL` variants will
/// be checked for equality with `glib.Variant.equal`, and their sort order is
/// otherwise undefined. `NULL` is ordered before non-`NULL` variants. Two `NULL`
/// values compare equal.
pub const ParamSpecVariant = extern struct {
    pub const Parent = gobject.ParamSpec;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = ParamSpecVariant;
    };
    /// private `gobject.ParamSpec` portion
    f_parent_instance: gobject.ParamSpec,
    /// a `glib.VariantType`, or `NULL`
    f_type: ?*glib.VariantType,
    /// a `glib.Variant`, or `NULL`
    f_default_value: ?*glib.Variant,
    f_padding: [4]*anyopaque,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn intern() usize;
    pub const getGObjectType = intern;

    pub fn as(p_instance: *ParamSpecVariant, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// `GSignalGroup` manages a collection of signals on a `GObject`.
///
/// `GSignalGroup` simplifies the process of connecting  many signals to a `GObject`
/// as a group. As such there is no API to disconnect a signal from the group.
///
/// In particular, this allows you to:
///
///  - Change the target instance, which automatically causes disconnection
///    of the signals from the old instance and connecting to the new instance.
///  - Block and unblock signals as a group
///  - Ensuring that blocked state transfers across target instances.
///
/// One place you might want to use such a structure is with `GtkTextView` and
/// `GtkTextBuffer`. Often times, you'll need to connect to many signals on
/// `GtkTextBuffer` from a `GtkTextView` subclass. This allows you to create a
/// signal group during instance construction, simply bind the
/// `GtkTextView:buffer` property to `GSignalGroup:target` and connect
/// all the signals you need. When the `GtkTextView:buffer` property changes
/// all of the signals will be transitioned correctly.
pub const SignalGroup = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = SignalGroup;
    };
    pub const virtual_methods = struct {};

    pub const properties = struct {
        /// The target instance used when connecting signals.
        pub const target = struct {
            pub const name = "target";

            pub const Type = ?*gobject.Object;
        };

        /// The `gobject.Type` of the target property.
        pub const target_type = struct {
            pub const name = "target-type";

            pub const Type = usize;
        };
    };

    pub const signals = struct {
        /// This signal is emitted when `gobject.SignalGroup.properties.target` is set to a new value
        /// other than `NULL`. It is similar to `gobject.Object.signals.notify` on `target` except it
        /// will not emit when `gobject.SignalGroup.properties.target` is `NULL` and also allows for
        /// receiving the `gobject.Object` without a data-race.
        pub const bind = struct {
            pub const name = "bind";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_instance: *gobject.Object, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SignalGroup, p_instance))),
                    gobject.signalLookup("bind", SignalGroup.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// This signal is emitted when the target instance of `self` is set to a
        /// new `gobject.Object`.
        ///
        /// This signal will only be emitted if the previous target of `self` is
        /// non-`NULL`.
        pub const unbind = struct {
            pub const name = "unbind";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SignalGroup, p_instance))),
                    gobject.signalLookup("unbind", SignalGroup.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Creates a new `gobject.SignalGroup` for target instances of `target_type`.
    extern fn g_signal_group_new(p_target_type: usize) *gobject.SignalGroup;
    pub const new = g_signal_group_new;

    /// Blocks all signal handlers managed by `self` so they will not
    /// be called during any signal emissions. Must be unblocked exactly
    /// the same number of times it has been blocked to become active again.
    ///
    /// This blocked state will be kept across changes of the target instance.
    extern fn g_signal_group_block(p_self: *SignalGroup) void;
    pub const block = g_signal_group_block;

    /// Connects `c_handler` to the signal `detailed_signal`
    /// on the target instance of `self`.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_data: ?*anyopaque) void;
    pub const connect = g_signal_group_connect;

    /// Connects `c_handler` to the signal `detailed_signal`
    /// on the target instance of `self`.
    ///
    /// The `c_handler` will be called after the default handler of the signal.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect_after(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_data: ?*anyopaque) void;
    pub const connectAfter = g_signal_group_connect_after;

    /// Connects `closure` to the signal `detailed_signal` on `gobject.SignalGroup.properties.target`.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect_closure(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_closure: *gobject.Closure, p_after: c_int) void;
    pub const connectClosure = g_signal_group_connect_closure;

    /// Connects `c_handler` to the signal `detailed_signal`
    /// on the target instance of `self`.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect_data(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_data: ?*anyopaque, p_notify: ?gobject.ClosureNotify, p_flags: gobject.ConnectFlags) void;
    pub const connectData = g_signal_group_connect_data;

    /// Connects `c_handler` to the signal `detailed_signal` on `gobject.SignalGroup.properties.target`.
    ///
    /// Ensures that the `object` stays alive during the call to `c_handler`
    /// by temporarily adding a reference count. When the `object` is destroyed
    /// the signal handler will automatically be removed.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect_object(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_object: *anyopaque, p_flags: gobject.ConnectFlags) void;
    pub const connectObject = g_signal_group_connect_object;

    /// Connects `c_handler` to the signal `detailed_signal`
    /// on the target instance of `self`.
    ///
    /// The instance on which the signal is emitted and `data`
    /// will be swapped when calling `c_handler`.
    ///
    /// You cannot connect a signal handler after `gobject.SignalGroup.properties.target` has been set.
    extern fn g_signal_group_connect_swapped(p_self: *SignalGroup, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_data: ?*anyopaque) void;
    pub const connectSwapped = g_signal_group_connect_swapped;

    /// Gets the target instance used when connecting signals.
    extern fn g_signal_group_dup_target(p_self: *SignalGroup) ?*gobject.Object;
    pub const dupTarget = g_signal_group_dup_target;

    /// Sets the target instance used when connecting signals. Any signal
    /// that has been registered with `gobject.SignalGroup.connectObject` or
    /// similar functions will be connected to this object.
    ///
    /// If the target instance was previously set, signals will be
    /// disconnected from that object prior to connecting to `target`.
    extern fn g_signal_group_set_target(p_self: *SignalGroup, p_target: ?*gobject.Object) void;
    pub const setTarget = g_signal_group_set_target;

    /// Unblocks all signal handlers managed by `self` so they will be
    /// called again during any signal emissions unless it is blocked
    /// again. Must be unblocked exactly the same number of times it
    /// has been blocked to become active again.
    extern fn g_signal_group_unblock(p_self: *SignalGroup) void;
    pub const unblock = g_signal_group_unblock;

    extern fn g_signal_group_get_type() usize;
    pub const getGObjectType = g_signal_group_get_type;

    extern fn g_object_ref(p_self: *gobject.SignalGroup) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.SignalGroup) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SignalGroup, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// `GTypeModule` provides a simple implementation of the `GTypePlugin`
/// interface.
///
/// The model of `GTypeModule` is a dynamically loaded module which
/// implements some number of types and interface implementations.
///
/// When the module is loaded, it registers its types and interfaces
/// using `gobject.TypeModule.registerType` and
/// `gobject.TypeModule.addInterface`.
/// As long as any instances of these types and interface implementations
/// are in use, the module is kept loaded. When the types and interfaces
/// are gone, the module may be unloaded. If the types and interfaces
/// become used again, the module will be reloaded. Note that the last
/// reference cannot be released from within the module code, since that
/// would lead to the caller's code being unloaded before ``gobject.Object.unref``
/// returns to it.
///
/// Keeping track of whether the module should be loaded or not is done by
/// using a use count - it starts at zero, and whenever it is greater than
/// zero, the module is loaded. The use count is maintained internally by
/// the type system, but also can be explicitly controlled by
/// `gobject.TypeModule.use` and `gobject.TypeModule.unuse`.
/// Typically, when loading a module for the first type, ``gobject.TypeModule.use``
/// will be used to load it so that it can initialize its types. At some later
/// point, when the module no longer needs to be loaded except for the type
/// implementations it contains, ``gobject.TypeModule.unuse`` is called.
///
/// `GTypeModule` does not actually provide any implementation of module
/// loading and unloading. To create a particular module type you must
/// derive from `GTypeModule` and implement the load and unload functions
/// in `GTypeModuleClass`.
pub const TypeModule = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{gobject.TypePlugin};
    pub const Class = gobject.TypeModuleClass;
    f_parent_instance: gobject.Object,
    f_use_count: c_uint,
    f_type_infos: ?*glib.SList,
    f_interface_infos: ?*glib.SList,
    /// the name of the module
    f_name: ?[*:0]u8,

    pub const virtual_methods = struct {
        /// loads the module and registers one or more types using
        ///  `gobject.TypeModule.registerType`.
        pub const load = struct {
            pub fn call(p_class: anytype, p_module: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(TypeModule.Class, p_class).f_load.?(gobject.ext.as(TypeModule, p_module));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_module: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(TypeModule.Class, p_class).f_load = @ptrCast(p_implementation);
            }
        };

        /// unloads the module
        pub const unload = struct {
            pub fn call(p_class: anytype, p_module: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(TypeModule.Class, p_class).f_unload.?(gobject.ext.as(TypeModule, p_module));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_module: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(TypeModule.Class, p_class).f_unload = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    /// Registers an additional interface for a type, whose interface lives
    /// in the given type plugin. If the interface was already registered
    /// for the type in this plugin, nothing will be done.
    ///
    /// As long as any instances of the type exist, the type plugin will
    /// not be unloaded.
    ///
    /// Since 2.56 if `module` is `NULL` this will call `gobject.typeAddInterfaceStatic`
    /// instead. This can be used when making a static build of the module.
    extern fn g_type_module_add_interface(p_module: ?*TypeModule, p_instance_type: usize, p_interface_type: usize, p_interface_info: *const gobject.InterfaceInfo) void;
    pub const addInterface = g_type_module_add_interface;

    /// Looks up or registers an enumeration that is implemented with a particular
    /// type plugin. If a type with name `type_name` was previously registered,
    /// the `gobject.Type` identifier for the type is returned, otherwise the type
    /// is newly registered, and the resulting `gobject.Type` identifier returned.
    ///
    /// As long as any instances of the type exist, the type plugin will
    /// not be unloaded.
    ///
    /// Since 2.56 if `module` is `NULL` this will call `gobject.typeRegisterStatic`
    /// instead. This can be used when making a static build of the module.
    extern fn g_type_module_register_enum(p_module: ?*TypeModule, p_name: [*:0]const u8, p_const_static_values: *const gobject.EnumValue) usize;
    pub const registerEnum = g_type_module_register_enum;

    /// Looks up or registers a flags type that is implemented with a particular
    /// type plugin. If a type with name `type_name` was previously registered,
    /// the `gobject.Type` identifier for the type is returned, otherwise the type
    /// is newly registered, and the resulting `gobject.Type` identifier returned.
    ///
    /// As long as any instances of the type exist, the type plugin will
    /// not be unloaded.
    ///
    /// Since 2.56 if `module` is `NULL` this will call `gobject.typeRegisterStatic`
    /// instead. This can be used when making a static build of the module.
    extern fn g_type_module_register_flags(p_module: ?*TypeModule, p_name: [*:0]const u8, p_const_static_values: *const gobject.FlagsValue) usize;
    pub const registerFlags = g_type_module_register_flags;

    /// Looks up or registers a type that is implemented with a particular
    /// type plugin. If a type with name `type_name` was previously registered,
    /// the `gobject.Type` identifier for the type is returned, otherwise the type
    /// is newly registered, and the resulting `gobject.Type` identifier returned.
    ///
    /// When reregistering a type (typically because a module is unloaded
    /// then reloaded, and reinitialized), `module` and `parent_type` must
    /// be the same as they were previously.
    ///
    /// As long as any instances of the type exist, the type plugin will
    /// not be unloaded.
    ///
    /// Since 2.56 if `module` is `NULL` this will call `gobject.typeRegisterStatic`
    /// instead. This can be used when making a static build of the module.
    extern fn g_type_module_register_type(p_module: ?*TypeModule, p_parent_type: usize, p_type_name: [*:0]const u8, p_type_info: *const gobject.TypeInfo, p_flags: gobject.TypeFlags) usize;
    pub const registerType = g_type_module_register_type;

    /// Sets the name for a `gobject.TypeModule`
    extern fn g_type_module_set_name(p_module: *TypeModule, p_name: [*:0]const u8) void;
    pub const setName = g_type_module_set_name;

    /// Decreases the use count of a `gobject.TypeModule` by one. If the
    /// result is zero, the module will be unloaded. (However, the
    /// `gobject.TypeModule` will not be freed, and types associated with the
    /// `gobject.TypeModule` are not unregistered. Once a `gobject.TypeModule` is
    /// initialized, it must exist forever.)
    extern fn g_type_module_unuse(p_module: *TypeModule) void;
    pub const unuse = g_type_module_unuse;

    /// Increases the use count of a `gobject.TypeModule` by one. If the
    /// use count was zero before, the plugin will be loaded.
    /// If loading the plugin fails, the use count is reset to
    /// its prior value.
    extern fn g_type_module_use(p_module: *TypeModule) c_int;
    pub const use = g_type_module_use;

    extern fn g_type_module_get_type() usize;
    pub const getGObjectType = g_type_module_get_type;

    extern fn g_object_ref(p_self: *gobject.TypeModule) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.TypeModule) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *TypeModule, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface that handles the lifecycle of dynamically loaded types.
///
/// The GObject type system supports dynamic loading of types.
/// It goes as follows:
///
/// 1. The type is initially introduced (usually upon loading the module
///    the first time, or by your main application that knows what modules
///    introduces what types), like this:
///    ```c
///    new_type_id = g_type_register_dynamic (parent_type_id,
///                                           "TypeName",
///                                           new_type_plugin,
///                                           type_flags);
///    ```
///    where `new_type_plugin` is an implementation of the
///    `GTypePlugin` interface.
///
/// 2. The type's implementation is referenced, e.g. through
///    `gobject.TypeClass.ref` or through `gobject.typeCreateInstance`
///    (this is being called by `gobject.Object.new`) or through one of the above
///    done on a type derived from `new_type_id`.
///
/// 3. This causes the type system to load the type's implementation by calling
///    `gobject.TypePlugin.use` and `gobject.TypePlugin.completeTypeInfo`
///    on `new_type_plugin`.
///
/// 4. At some point the type's implementation isn't required anymore, e.g. after
///    `gobject.TypeClass.unref` or `gobject.typeFreeInstance`
///    (called when the reference count of an instance drops to zero).
///
/// 5. This causes the type system to throw away the information retrieved
///    from `gobject.TypePlugin.completeTypeInfo` and then it calls
///    `gobject.TypePlugin.unuse` on `new_type_plugin`.
///
/// 6. Things may repeat from the second step.
///
/// So basically, you need to implement a `GTypePlugin` type that
/// carries a use_count, once use_count goes from zero to one, you need
/// to load the implementation to successfully handle the upcoming
/// `gobject.TypePlugin.completeTypeInfo` call. Later, maybe after
/// succeeding use/unuse calls, once use_count drops to zero, you can
/// unload the implementation again. The type system makes sure to call
/// `gobject.TypePlugin.use` and `gobject.TypePlugin.completeTypeInfo`
/// again when the type is needed again.
///
/// `gobject.TypeModule` is an implementation of `GTypePlugin` that
/// already implements most of this except for the actual module loading and
/// unloading. It even handles multiple registered types per module.
pub const TypePlugin = opaque {
    pub const Prerequisites = [_]type{gobject.Object};
    pub const Iface = opaque {
        pub const Instance = TypePlugin;
    };
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Calls the `complete_interface_info` function from the
    /// `gobject.TypePluginClass` of `plugin`. There should be no need to use this
    /// function outside of the GObject type system itself.
    extern fn g_type_plugin_complete_interface_info(p_plugin: *TypePlugin, p_instance_type: usize, p_interface_type: usize, p_info: *gobject.InterfaceInfo) void;
    pub const completeInterfaceInfo = g_type_plugin_complete_interface_info;

    /// Calls the `complete_type_info` function from the `gobject.TypePluginClass` of `plugin`.
    /// There should be no need to use this function outside of the GObject
    /// type system itself.
    extern fn g_type_plugin_complete_type_info(p_plugin: *TypePlugin, p_g_type: usize, p_info: *gobject.TypeInfo, p_value_table: *gobject.TypeValueTable) void;
    pub const completeTypeInfo = g_type_plugin_complete_type_info;

    /// Calls the `unuse_plugin` function from the `gobject.TypePluginClass` of
    /// `plugin`.  There should be no need to use this function outside of
    /// the GObject type system itself.
    extern fn g_type_plugin_unuse(p_plugin: *TypePlugin) void;
    pub const unuse = g_type_plugin_unuse;

    /// Calls the `use_plugin` function from the `gobject.TypePluginClass` of
    /// `plugin`.  There should be no need to use this function outside of
    /// the GObject type system itself.
    extern fn g_type_plugin_use(p_plugin: *TypePlugin) void;
    pub const use = g_type_plugin_use;

    extern fn g_type_plugin_get_type() usize;
    pub const getGObjectType = g_type_plugin_get_type;

    extern fn g_object_ref(p_self: *gobject.TypePlugin) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *gobject.TypePlugin) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *TypePlugin, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.CClosure` is a specialization of `gobject.Closure` for C function callbacks.
pub const CClosure = extern struct {
    /// the `gobject.Closure`
    f_closure: gobject.Closure,
    /// the callback function
    f_callback: ?*anyopaque,

    /// A `gobject.ClosureMarshal` function for use with signals with handlers that
    /// take two boxed pointers as arguments and return a boolean.  If you
    /// have such a signal, you will probably also need to use an
    /// accumulator, such as `gobject.signalAccumulatorTrueHandled`.
    extern fn g_cclosure_marshal_BOOLEAN__BOXED_BOXED(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalBOOLEANBOXEDBOXED = g_cclosure_marshal_BOOLEAN__BOXED_BOXED;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalBOOLEANBOXEDBOXED`.
    extern fn g_cclosure_marshal_BOOLEAN__BOXED_BOXEDv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalBOOLEANBOXEDBOXEDv = g_cclosure_marshal_BOOLEAN__BOXED_BOXEDv;

    /// A `gobject.ClosureMarshal` function for use with signals with handlers that
    /// take a flags type as an argument and return a boolean.  If you have
    /// such a signal, you will probably also need to use an accumulator,
    /// such as `gobject.signalAccumulatorTrueHandled`.
    extern fn g_cclosure_marshal_BOOLEAN__FLAGS(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalBOOLEANFLAGS = g_cclosure_marshal_BOOLEAN__FLAGS;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalBOOLEANFLAGS`.
    extern fn g_cclosure_marshal_BOOLEAN__FLAGSv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalBOOLEANFLAGSv = g_cclosure_marshal_BOOLEAN__FLAGSv;

    /// A `gobject.ClosureMarshal` function for use with signals with handlers that
    /// take a `gobject.Object` and a pointer and produce a string.  It is highly
    /// unlikely that your signal handler fits this description.
    extern fn g_cclosure_marshal_STRING__OBJECT_POINTER(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalSTRINGOBJECTPOINTER = g_cclosure_marshal_STRING__OBJECT_POINTER;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalSTRINGOBJECTPOINTER`.
    extern fn g_cclosure_marshal_STRING__OBJECT_POINTERv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalSTRINGOBJECTPOINTERv = g_cclosure_marshal_STRING__OBJECT_POINTERv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// boolean argument.
    extern fn g_cclosure_marshal_VOID__BOOLEAN(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDBOOLEAN = g_cclosure_marshal_VOID__BOOLEAN;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDBOOLEAN`.
    extern fn g_cclosure_marshal_VOID__BOOLEANv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDBOOLEANv = g_cclosure_marshal_VOID__BOOLEANv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// argument which is any boxed pointer type.
    extern fn g_cclosure_marshal_VOID__BOXED(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDBOXED = g_cclosure_marshal_VOID__BOXED;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDBOXED`.
    extern fn g_cclosure_marshal_VOID__BOXEDv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDBOXEDv = g_cclosure_marshal_VOID__BOXEDv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// character argument.
    extern fn g_cclosure_marshal_VOID__CHAR(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDCHAR = g_cclosure_marshal_VOID__CHAR;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDCHAR`.
    extern fn g_cclosure_marshal_VOID__CHARv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDCHARv = g_cclosure_marshal_VOID__CHARv;

    /// A `gobject.ClosureMarshal` function for use with signals with one
    /// double-precision floating point argument.
    extern fn g_cclosure_marshal_VOID__DOUBLE(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDDOUBLE = g_cclosure_marshal_VOID__DOUBLE;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDDOUBLE`.
    extern fn g_cclosure_marshal_VOID__DOUBLEv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDDOUBLEv = g_cclosure_marshal_VOID__DOUBLEv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// argument with an enumerated type.
    extern fn g_cclosure_marshal_VOID__ENUM(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDENUM = g_cclosure_marshal_VOID__ENUM;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDENUM`.
    extern fn g_cclosure_marshal_VOID__ENUMv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDENUMv = g_cclosure_marshal_VOID__ENUMv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// argument with a flags types.
    extern fn g_cclosure_marshal_VOID__FLAGS(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDFLAGS = g_cclosure_marshal_VOID__FLAGS;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDFLAGS`.
    extern fn g_cclosure_marshal_VOID__FLAGSv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDFLAGSv = g_cclosure_marshal_VOID__FLAGSv;

    /// A `gobject.ClosureMarshal` function for use with signals with one
    /// single-precision floating point argument.
    extern fn g_cclosure_marshal_VOID__FLOAT(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDFLOAT = g_cclosure_marshal_VOID__FLOAT;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDFLOAT`.
    extern fn g_cclosure_marshal_VOID__FLOATv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDFLOATv = g_cclosure_marshal_VOID__FLOATv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// integer argument.
    extern fn g_cclosure_marshal_VOID__INT(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDINT = g_cclosure_marshal_VOID__INT;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDINT`.
    extern fn g_cclosure_marshal_VOID__INTv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDINTv = g_cclosure_marshal_VOID__INTv;

    /// A `gobject.ClosureMarshal` function for use with signals with with a single
    /// long integer argument.
    extern fn g_cclosure_marshal_VOID__LONG(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDLONG = g_cclosure_marshal_VOID__LONG;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDLONG`.
    extern fn g_cclosure_marshal_VOID__LONGv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDLONGv = g_cclosure_marshal_VOID__LONGv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// `gobject.Object` argument.
    extern fn g_cclosure_marshal_VOID__OBJECT(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDOBJECT = g_cclosure_marshal_VOID__OBJECT;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDOBJECT`.
    extern fn g_cclosure_marshal_VOID__OBJECTv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDOBJECTv = g_cclosure_marshal_VOID__OBJECTv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// argument of type `gobject.ParamSpec`.
    extern fn g_cclosure_marshal_VOID__PARAM(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDPARAM = g_cclosure_marshal_VOID__PARAM;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDPARAM`.
    extern fn g_cclosure_marshal_VOID__PARAMv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDPARAMv = g_cclosure_marshal_VOID__PARAMv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single raw
    /// pointer argument type.
    ///
    /// If it is possible, it is better to use one of the more specific
    /// functions such as `gobject.cclosureMarshalVOIDOBJECT` or
    /// `gobject.cclosureMarshalVOIDOBJECT`.
    extern fn g_cclosure_marshal_VOID__POINTER(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDPOINTER = g_cclosure_marshal_VOID__POINTER;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDPOINTER`.
    extern fn g_cclosure_marshal_VOID__POINTERv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDPOINTERv = g_cclosure_marshal_VOID__POINTERv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single string
    /// argument.
    extern fn g_cclosure_marshal_VOID__STRING(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDSTRING = g_cclosure_marshal_VOID__STRING;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDSTRING`.
    extern fn g_cclosure_marshal_VOID__STRINGv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDSTRINGv = g_cclosure_marshal_VOID__STRINGv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// unsigned character argument.
    extern fn g_cclosure_marshal_VOID__UCHAR(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDUCHAR = g_cclosure_marshal_VOID__UCHAR;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDUCHAR`.
    extern fn g_cclosure_marshal_VOID__UCHARv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDUCHARv = g_cclosure_marshal_VOID__UCHARv;

    /// A `gobject.ClosureMarshal` function for use with signals with with a single
    /// unsigned integer argument.
    extern fn g_cclosure_marshal_VOID__UINT(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDUINT = g_cclosure_marshal_VOID__UINT;

    /// A `gobject.ClosureMarshal` function for use with signals with an unsigned int
    /// and a pointer as arguments.
    extern fn g_cclosure_marshal_VOID__UINT_POINTER(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDUINTPOINTER = g_cclosure_marshal_VOID__UINT_POINTER;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDUINTPOINTER`.
    extern fn g_cclosure_marshal_VOID__UINT_POINTERv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDUINTPOINTERv = g_cclosure_marshal_VOID__UINT_POINTERv;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDUINT`.
    extern fn g_cclosure_marshal_VOID__UINTv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDUINTv = g_cclosure_marshal_VOID__UINTv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// unsigned long integer argument.
    extern fn g_cclosure_marshal_VOID__ULONG(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDULONG = g_cclosure_marshal_VOID__ULONG;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDULONG`.
    extern fn g_cclosure_marshal_VOID__ULONGv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDULONGv = g_cclosure_marshal_VOID__ULONGv;

    /// A `gobject.ClosureMarshal` function for use with signals with a single
    /// `glib.Variant` argument.
    extern fn g_cclosure_marshal_VOID__VARIANT(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDVARIANT = g_cclosure_marshal_VOID__VARIANT;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDVARIANT`.
    extern fn g_cclosure_marshal_VOID__VARIANTv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDVARIANTv = g_cclosure_marshal_VOID__VARIANTv;

    /// A `gobject.ClosureMarshal` function for use with signals with no arguments.
    extern fn g_cclosure_marshal_VOID__VOID(p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalVOIDVOID = g_cclosure_marshal_VOID__VOID;

    /// The `gobject.VaClosureMarshal` equivalent to `gobject.cclosureMarshalVOIDVOID`.
    extern fn g_cclosure_marshal_VOID__VOIDv(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalVOIDVOIDv = g_cclosure_marshal_VOID__VOIDv;

    /// A generic marshaller function implemented via
    /// [libffi](http://sourceware.org/libffi/).
    ///
    /// Normally this function is not passed explicitly to `gobject.signalNew`,
    /// but used automatically by GLib when specifying a `NULL` marshaller.
    extern fn g_cclosure_marshal_generic(p_closure: *gobject.Closure, p_return_gvalue: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) void;
    pub const marshalGeneric = g_cclosure_marshal_generic;

    /// A generic `gobject.VaClosureMarshal` function implemented via
    /// [libffi](http://sourceware.org/libffi/).
    extern fn g_cclosure_marshal_generic_va(p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args_list: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) void;
    pub const marshalGenericVa = g_cclosure_marshal_generic_va;

    /// Creates a new closure which invokes `callback_func` with `user_data` as
    /// the last parameter.
    ///
    /// `destroy_data` will be called as a finalize notifier on the `gobject.Closure`.
    extern fn g_cclosure_new(p_callback_func: gobject.Callback, p_user_data: ?*anyopaque, p_destroy_data: ?gobject.ClosureNotify) *gobject.Closure;
    pub const new = g_cclosure_new;

    /// A variant of `gobject.cclosureNew` which uses `object` as `user_data` and
    /// calls `gobject.Object.watchClosure` on `object` and the created
    /// closure. This function is useful when you have a callback closely
    /// associated with a `gobject.Object`, and want the callback to no longer run
    /// after the object is is freed.
    extern fn g_cclosure_new_object(p_callback_func: gobject.Callback, p_object: *gobject.Object) *gobject.Closure;
    pub const newObject = g_cclosure_new_object;

    /// A variant of `gobject.cclosureNewSwap` which uses `object` as `user_data`
    /// and calls `gobject.Object.watchClosure` on `object` and the created
    /// closure. This function is useful when you have a callback closely
    /// associated with a `gobject.Object`, and want the callback to no longer run
    /// after the object is is freed.
    extern fn g_cclosure_new_object_swap(p_callback_func: gobject.Callback, p_object: *gobject.Object) *gobject.Closure;
    pub const newObjectSwap = g_cclosure_new_object_swap;

    /// Creates a new closure which invokes `callback_func` with `user_data` as
    /// the first parameter.
    ///
    /// `destroy_data` will be called as a finalize notifier on the `gobject.Closure`.
    extern fn g_cclosure_new_swap(p_callback_func: gobject.Callback, p_user_data: ?*anyopaque, p_destroy_data: ?gobject.ClosureNotify) *gobject.Closure;
    pub const newSwap = g_cclosure_new_swap;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `GClosure` represents a callback supplied by the programmer.
///
/// It will generally comprise a function of some kind and a marshaller
/// used to call it. It is the responsibility of the marshaller to
/// convert the arguments for the invocation from `GValues` into
/// a suitable form, perform the callback on the converted arguments,
/// and transform the return value back into a `gobject.Value`.
///
/// In the case of C programs, a closure usually just holds a pointer
/// to a function and maybe a data argument, and the marshaller
/// converts between `gobject.Value` and native C types. The GObject
/// library provides the `gobject.CClosure` type for this purpose. Bindings for
/// other languages need marshallers which convert between `GValues`
/// and suitable representations in the runtime of the language in
/// order to use functions written in that language as callbacks. Use
/// `gobject.Closure.setMarshal` to set the marshaller on such a custom
/// closure implementation.
///
/// Within GObject, closures play an important role in the
/// implementation of signals. When a signal is registered, the
/// `c_marshaller` argument to `gobject.signalNew` specifies the default C
/// marshaller for any closure which is connected to this
/// signal. GObject provides a number of C marshallers for this
/// purpose, see the g_cclosure_marshal_*() functions. Additional C
/// marshallers can be generated with the [glib-genmarshal][glib-genmarshal]
/// utility.  Closures can be explicitly connected to signals with
/// `gobject.signalConnectClosure`, but it usually more convenient to let
/// GObject create a closure automatically by using one of the
/// g_signal_connect_*() functions which take a callback function/user
/// data pair.
///
/// Using closures has a number of important advantages over a simple
/// callback function/data pointer combination:
///
/// - Closures allow the callee to get the types of the callback parameters,
///   which means that language bindings don't have to write individual glue
///   for each callback type.
///
/// - The reference counting of `gobject.Closure` makes it easy to handle reentrancy
///   right; if a callback is removed while it is being invoked, the closure
///   and its parameters won't be freed until the invocation finishes.
///
/// - `gobject.Closure.invalidate` and invalidation notifiers allow callbacks to be
///   automatically removed when the objects they point to go away.
pub const Closure = extern struct {
    bitfields0: packed struct(c_uint) {
        f_ref_count: u15,
        f_meta_marshal_nouse: u1,
        f_n_guards: u1,
        f_n_fnotifiers: u2,
        f_n_inotifiers: u8,
        f_in_inotify: u1,
        f_floating: u1,
        f_derivative_flag: u1,
        /// Indicates whether the closure is currently being invoked with
        ///   `gobject.Closure.invoke`
        f_in_marshal: u1,
        /// Indicates whether the closure has been invalidated by
        ///   `gobject.Closure.invalidate`
        f_is_invalid: u1,
    },
    f_marshal: ?*const fn (p_closure: *gobject.Closure, p_return_value: *gobject.Value, p_n_param_values: c_uint, p_param_values: *const gobject.Value, p_invocation_hint: *anyopaque, p_marshal_data: *anyopaque) callconv(.c) void,
    f_data: ?*anyopaque,
    f_notifiers: ?*gobject.ClosureNotifyData,

    /// A variant of `gobject.Closure.newSimple` which stores `object` in the
    /// `data` field of the closure and calls `gobject.Object.watchClosure` on
    /// `object` and the created closure. This function is mainly useful
    /// when implementing new types of closures.
    extern fn g_closure_new_object(p_sizeof_closure: c_uint, p_object: *gobject.Object) *gobject.Closure;
    pub const newObject = g_closure_new_object;

    /// Allocates a struct of the given size and initializes the initial
    /// part as a `gobject.Closure`.
    ///
    /// This function is mainly useful when implementing new types of closures:
    ///
    /// ```
    /// typedef struct _MyClosure MyClosure;
    /// struct _MyClosure
    /// {
    ///   GClosure closure;
    ///   // extra data goes here
    /// };
    ///
    /// static void
    /// my_closure_finalize (gpointer  notify_data,
    ///                      GClosure *closure)
    /// {
    ///   MyClosure *my_closure = (MyClosure *)closure;
    ///
    ///   // free extra data here
    /// }
    ///
    /// MyClosure *my_closure_new (gpointer data)
    /// {
    ///   GClosure *closure;
    ///   MyClosure *my_closure;
    ///
    ///   closure = g_closure_new_simple (sizeof (MyClosure), data);
    ///   my_closure = (MyClosure *) closure;
    ///
    ///   // initialize extra data here
    ///
    ///   g_closure_add_finalize_notifier (closure, notify_data,
    ///                                    my_closure_finalize);
    ///   return my_closure;
    /// }
    /// ```
    extern fn g_closure_new_simple(p_sizeof_closure: c_uint, p_data: ?*anyopaque) *gobject.Closure;
    pub const newSimple = g_closure_new_simple;

    /// Registers a finalization notifier which will be called when the
    /// reference count of `closure` goes down to 0.
    ///
    /// Multiple finalization notifiers on a single closure are invoked in
    /// unspecified order. If a single call to `gobject.Closure.unref` results in
    /// the closure being both invalidated and finalized, then the invalidate
    /// notifiers will be run before the finalize notifiers.
    extern fn g_closure_add_finalize_notifier(p_closure: *Closure, p_notify_data: ?*anyopaque, p_notify_func: gobject.ClosureNotify) void;
    pub const addFinalizeNotifier = g_closure_add_finalize_notifier;

    /// Registers an invalidation notifier which will be called when the
    /// `closure` is invalidated with `gobject.Closure.invalidate`.
    ///
    /// Invalidation notifiers are invoked before finalization notifiers,
    /// in an unspecified order.
    extern fn g_closure_add_invalidate_notifier(p_closure: *Closure, p_notify_data: ?*anyopaque, p_notify_func: gobject.ClosureNotify) void;
    pub const addInvalidateNotifier = g_closure_add_invalidate_notifier;

    /// Adds a pair of notifiers which get invoked before and after the
    /// closure callback, respectively.
    ///
    /// This is typically used to protect the extra arguments for the
    /// duration of the callback. See `gobject.Object.watchClosure` for an
    /// example of marshal guards.
    extern fn g_closure_add_marshal_guards(p_closure: *Closure, p_pre_marshal_data: ?*anyopaque, p_pre_marshal_notify: gobject.ClosureNotify, p_post_marshal_data: ?*anyopaque, p_post_marshal_notify: gobject.ClosureNotify) void;
    pub const addMarshalGuards = g_closure_add_marshal_guards;

    /// Sets a flag on the closure to indicate that its calling
    /// environment has become invalid, and thus causes any future
    /// invocations of `gobject.Closure.invoke` on this `closure` to be
    /// ignored.
    ///
    /// Also, invalidation notifiers installed on the closure will
    /// be called at this point. Note that unless you are holding a
    /// reference to the closure yourself, the invalidation notifiers may
    /// unref the closure and cause it to be destroyed, so if you need to
    /// access the closure after calling `gobject.Closure.invalidate`, make sure
    /// that you've previously called `gobject.Closure.ref`.
    ///
    /// Note that `gobject.Closure.invalidate` will also be called when the
    /// reference count of a closure drops to zero (unless it has already
    /// been invalidated before).
    extern fn g_closure_invalidate(p_closure: *Closure) void;
    pub const invalidate = g_closure_invalidate;

    /// Invokes the closure, i.e. executes the callback represented by the `closure`.
    extern fn g_closure_invoke(p_closure: *Closure, p_return_value: ?*gobject.Value, p_n_param_values: c_uint, p_param_values: [*]const gobject.Value, p_invocation_hint: ?*anyopaque) void;
    pub const invoke = g_closure_invoke;

    /// Increments the reference count on a closure to force it staying
    /// alive while the caller holds a pointer to it.
    extern fn g_closure_ref(p_closure: *Closure) *gobject.Closure;
    pub const ref = g_closure_ref;

    /// Removes a finalization notifier.
    ///
    /// Notice that notifiers are automatically removed after they are run.
    extern fn g_closure_remove_finalize_notifier(p_closure: *Closure, p_notify_data: ?*anyopaque, p_notify_func: gobject.ClosureNotify) void;
    pub const removeFinalizeNotifier = g_closure_remove_finalize_notifier;

    /// Removes an invalidation notifier.
    ///
    /// Notice that notifiers are automatically removed after they are run.
    extern fn g_closure_remove_invalidate_notifier(p_closure: *Closure, p_notify_data: ?*anyopaque, p_notify_func: gobject.ClosureNotify) void;
    pub const removeInvalidateNotifier = g_closure_remove_invalidate_notifier;

    /// Sets the marshaller of `closure`.
    ///
    /// The `marshal_data` of `marshal` provides a way for a meta marshaller to
    /// provide additional information to the marshaller.
    ///
    /// For GObject's C predefined marshallers (the `g_cclosure_marshal_*()`
    /// functions), what it provides is a callback function to use instead of
    /// `closure`->callback.
    ///
    /// See also: `gobject.Closure.setMetaMarshal`
    extern fn g_closure_set_marshal(p_closure: *Closure, p_marshal: gobject.ClosureMarshal) void;
    pub const setMarshal = g_closure_set_marshal;

    /// Sets the meta marshaller of `closure`.
    ///
    /// A meta marshaller wraps the `closure`'s marshal and modifies the way
    /// it is called in some fashion. The most common use of this facility
    /// is for C callbacks.
    ///
    /// The same marshallers (generated by [glib-genmarshal][glib-genmarshal]),
    /// are used everywhere, but the way that we get the callback function
    /// differs. In most cases we want to use the `closure`'s callback, but in
    /// other cases we want to use some different technique to retrieve the
    /// callback function.
    ///
    /// For example, class closures for signals (see
    /// `gobject.signalTypeCclosureNew`) retrieve the callback function from a
    /// fixed offset in the class structure.  The meta marshaller retrieves
    /// the right callback and passes it to the marshaller as the
    /// `marshal_data` argument.
    extern fn g_closure_set_meta_marshal(p_closure: *Closure, p_marshal_data: ?*anyopaque, p_meta_marshal: gobject.ClosureMarshal) void;
    pub const setMetaMarshal = g_closure_set_meta_marshal;

    /// Takes over the initial ownership of a closure.
    ///
    /// Each closure is initially created in a "floating" state, which means
    /// that the initial reference count is not owned by any caller.
    ///
    /// This function checks to see if the object is still floating, and if so,
    /// unsets the floating state and decreases the reference count. If the
    /// closure is not floating, `gobject.Closure.sink` does nothing.
    ///
    /// The reason for the existence of the floating state is to prevent
    /// cumbersome code sequences like:
    ///
    /// ```
    /// closure = g_cclosure_new (cb_func, cb_data);
    /// g_source_set_closure (source, closure);
    /// g_closure_unref (closure); // GObject doesn't really need this
    /// ```
    ///
    /// Because `gobject.sourceSetClosure` (and similar functions) take ownership of the
    /// initial reference count, if it is unowned, we instead can write:
    ///
    /// ```
    /// g_source_set_closure (source, g_cclosure_new (cb_func, cb_data));
    /// ```
    ///
    /// Generally, this function is used together with `gobject.Closure.ref`. An example
    /// of storing a closure for later notification looks like:
    ///
    /// ```
    /// static GClosure *notify_closure = NULL;
    /// void
    /// foo_notify_set_closure (GClosure *closure)
    /// {
    ///   if (notify_closure)
    ///     g_closure_unref (notify_closure);
    ///   notify_closure = closure;
    ///   if (notify_closure)
    ///     {
    ///       g_closure_ref (notify_closure);
    ///       g_closure_sink (notify_closure);
    ///     }
    /// }
    /// ```
    ///
    /// Because `gobject.Closure.sink` may decrement the reference count of a closure
    /// (if it hasn't been called on `closure` yet) just like `gobject.Closure.unref`,
    /// `gobject.Closure.ref` should be called prior to this function.
    extern fn g_closure_sink(p_closure: *Closure) void;
    pub const sink = g_closure_sink;

    /// Decrements the reference count of a closure after it was previously
    /// incremented by the same caller.
    ///
    /// If no other callers are using the closure, then the closure will be
    /// destroyed and freed.
    extern fn g_closure_unref(p_closure: *Closure) void;
    pub const unref = g_closure_unref;

    extern fn g_closure_get_type() usize;
    pub const getGObjectType = g_closure_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ClosureNotifyData = extern struct {
    f_data: ?*anyopaque,
    f_notify: ?gobject.ClosureNotify,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The class of an enumeration type holds information about its
/// possible values.
pub const EnumClass = extern struct {
    /// the parent class
    f_g_type_class: gobject.TypeClass,
    /// the smallest possible value.
    f_minimum: c_int,
    /// the largest possible value.
    f_maximum: c_int,
    /// the number of possible values.
    f_n_values: c_uint,
    /// an array of `gobject.EnumValue` structs describing the
    ///  individual values.
    f_values: ?*gobject.EnumValue,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure which contains a single enum value, its name, and its
/// nickname.
pub const EnumValue = extern struct {
    /// the enum value
    f_value: c_int,
    /// the name of the value
    f_value_name: ?[*:0]const u8,
    /// the nickname of the value
    f_value_nick: ?[*:0]const u8,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The class of a flags type holds information about its
/// possible values.
pub const FlagsClass = extern struct {
    /// the parent class
    f_g_type_class: gobject.TypeClass,
    /// a mask covering all possible values.
    f_mask: c_uint,
    /// the number of possible values.
    f_n_values: c_uint,
    /// an array of `gobject.FlagsValue` structs describing the
    ///  individual values.
    f_values: ?*gobject.FlagsValue,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure which contains a single flags value, its name, and its
/// nickname.
pub const FlagsValue = extern struct {
    /// the flags value
    f_value: c_uint,
    /// the name of the value
    f_value_name: ?[*:0]const u8,
    /// the nickname of the value
    f_value_nick: ?[*:0]const u8,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The class structure for the GInitiallyUnowned type.
pub const InitiallyUnownedClass = extern struct {
    pub const Instance = gobject.InitiallyUnowned;

    /// the parent class
    f_g_type_class: gobject.TypeClass,
    f_construct_properties: ?*glib.SList,
    /// the `constructor` function is called by g_object_new () to
    ///  complete the object initialization after all the construction properties are
    ///  set. The first thing a `constructor` implementation must do is chain up to the
    ///  `constructor` of the parent class. Overriding `constructor` should be rarely
    ///  needed, e.g. to handle construct properties, or to implement singletons.
    f_constructor: ?*const fn (p_type: usize, p_n_construct_properties: c_uint, p_construct_properties: *gobject.ObjectConstructParam) callconv(.c) *gobject.Object,
    /// the generic setter for all properties of this type. Should be
    ///  overridden for every type with properties. If implementations of
    ///  `set_property` don't emit property change notification explicitly, this will
    ///  be done implicitly by the type system. However, if the notify signal is
    ///  emitted explicitly, the type system will not emit it a second time.
    f_set_property: ?*const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the generic getter for all properties of this type. Should be
    ///  overridden for every type with properties.
    f_get_property: ?*const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the `dispose` function is supposed to drop all references to other
    ///  objects, but keep the instance otherwise intact, so that client method
    ///  invocations still work. It may be run multiple times (due to reference
    ///  loops). Before returning, `dispose` should chain up to the `dispose` method
    ///  of the parent class.
    f_dispose: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    /// instance finalization function, should finish the finalization of
    ///  the instance begun in `dispose` and chain up to the `finalize` method of the
    ///  parent class.
    f_finalize: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    /// emits property change notification for a bunch
    ///  of properties. Overriding `dispatch_properties_changed` should be rarely
    ///  needed.
    f_dispatch_properties_changed: ?*const fn (p_object: *gobject.Object, p_n_pspecs: c_uint, p_pspecs: **gobject.ParamSpec) callconv(.c) void,
    /// the class closure for the notify signal
    f_notify: ?*const fn (p_object: *gobject.Object, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the `constructed` function is called by `gobject.Object.new` as the
    ///  final step of the object creation process.  At the point of the call, all
    ///  construction properties have been set on the object.  The purpose of this
    ///  call is to allow for object initialisation steps that can only be performed
    ///  after construction properties have been set.  `constructed` implementors
    ///  should chain up to the `constructed` call of their parent class to allow it
    ///  to complete its initialisation.
    f_constructed: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    f_flags: usize,
    f_n_construct_properties: usize,
    f_pspecs: ?*anyopaque,
    f_n_pspecs: usize,
    f_pdummy: [3]*anyopaque,

    pub fn as(p_instance: *InitiallyUnownedClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure that provides information to the type system which is
/// used specifically for managing interface types.
pub const InterfaceInfo = extern struct {
    /// location of the interface initialization function
    f_interface_init: ?gobject.InterfaceInitFunc,
    /// location of the interface finalization function
    f_interface_finalize: ?gobject.InterfaceFinalizeFunc,
    /// user-supplied data passed to the interface init/finalize functions
    f_interface_data: ?*anyopaque,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The class structure for the GObject type.
///
/// ```
/// // Example of implementing a singleton using a constructor.
/// static MySingleton *the_singleton = NULL;
///
/// static GObject*
/// my_singleton_constructor (GType                  type,
///                           guint                  n_construct_params,
///                           GObjectConstructParam *construct_params)
/// {
///   GObject *object;
///
///   if (!the_singleton)
///     {
///       object = G_OBJECT_CLASS (parent_class)->constructor (type,
///                                                            n_construct_params,
///                                                            construct_params);
///       the_singleton = MY_SINGLETON (object);
///     }
///   else
///     object = g_object_ref (G_OBJECT (the_singleton));
///
///   return object;
/// }
/// ```
pub const ObjectClass = extern struct {
    pub const Instance = gobject.Object;

    /// the parent class
    f_g_type_class: gobject.TypeClass,
    f_construct_properties: ?*glib.SList,
    /// the `constructor` function is called by g_object_new () to
    ///  complete the object initialization after all the construction properties are
    ///  set. The first thing a `constructor` implementation must do is chain up to the
    ///  `constructor` of the parent class. Overriding `constructor` should be rarely
    ///  needed, e.g. to handle construct properties, or to implement singletons.
    f_constructor: ?*const fn (p_type: usize, p_n_construct_properties: c_uint, p_construct_properties: *gobject.ObjectConstructParam) callconv(.c) *gobject.Object,
    /// the generic setter for all properties of this type. Should be
    ///  overridden for every type with properties. If implementations of
    ///  `set_property` don't emit property change notification explicitly, this will
    ///  be done implicitly by the type system. However, if the notify signal is
    ///  emitted explicitly, the type system will not emit it a second time.
    f_set_property: ?*const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the generic getter for all properties of this type. Should be
    ///  overridden for every type with properties.
    f_get_property: ?*const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the `dispose` function is supposed to drop all references to other
    ///  objects, but keep the instance otherwise intact, so that client method
    ///  invocations still work. It may be run multiple times (due to reference
    ///  loops). Before returning, `dispose` should chain up to the `dispose` method
    ///  of the parent class.
    f_dispose: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    /// instance finalization function, should finish the finalization of
    ///  the instance begun in `dispose` and chain up to the `finalize` method of the
    ///  parent class.
    f_finalize: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    /// emits property change notification for a bunch
    ///  of properties. Overriding `dispatch_properties_changed` should be rarely
    ///  needed.
    f_dispatch_properties_changed: ?*const fn (p_object: *gobject.Object, p_n_pspecs: c_uint, p_pspecs: **gobject.ParamSpec) callconv(.c) void,
    /// the class closure for the notify signal
    f_notify: ?*const fn (p_object: *gobject.Object, p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// the `constructed` function is called by `gobject.Object.new` as the
    ///  final step of the object creation process.  At the point of the call, all
    ///  construction properties have been set on the object.  The purpose of this
    ///  call is to allow for object initialisation steps that can only be performed
    ///  after construction properties have been set.  `constructed` implementors
    ///  should chain up to the `constructed` call of their parent class to allow it
    ///  to complete its initialisation.
    f_constructed: ?*const fn (p_object: *gobject.Object) callconv(.c) void,
    f_flags: usize,
    f_n_construct_properties: usize,
    f_pspecs: ?*anyopaque,
    f_n_pspecs: usize,
    f_pdummy: [3]*anyopaque,

    /// Looks up the `gobject.ParamSpec` for a property of a class.
    extern fn g_object_class_find_property(p_oclass: *ObjectClass, p_property_name: [*:0]const u8) *gobject.ParamSpec;
    pub const findProperty = g_object_class_find_property;

    /// Installs new properties from an array of `GParamSpecs`.
    ///
    /// All properties should be installed during the class initializer.  It
    /// is possible to install properties after that, but doing so is not
    /// recommend, and specifically, is not guaranteed to be thread-safe vs.
    /// use of properties on the same type on other threads.
    ///
    /// The property id of each property is the index of each `gobject.ParamSpec` in
    /// the `pspecs` array.
    ///
    /// The property id of 0 is treated specially by `gobject.Object` and it should not
    /// be used to store a `gobject.ParamSpec`.
    ///
    /// This function should be used if you plan to use a static array of
    /// `GParamSpecs` and `gobject.Object.notifyByPspec`. For instance, this
    /// class initialization:
    ///
    /// ```
    /// typedef enum {
    ///   PROP_FOO = 1,
    ///   PROP_BAR,
    ///   N_PROPERTIES
    /// } MyObjectProperty;
    ///
    /// static GParamSpec *obj_properties[N_PROPERTIES] = { NULL, };
    ///
    /// static void
    /// my_object_class_init (MyObjectClass *klass)
    /// {
    ///   GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
    ///
    ///   obj_properties[PROP_FOO] =
    ///     g_param_spec_int ("foo", NULL, NULL,
    ///                       -1, G_MAXINT,
    ///                       0,
    ///                       G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);
    ///
    ///   obj_properties[PROP_BAR] =
    ///     g_param_spec_string ("bar", NULL, NULL,
    ///                          NULL,
    ///                          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);
    ///
    ///   gobject_class->set_property = my_object_set_property;
    ///   gobject_class->get_property = my_object_get_property;
    ///   g_object_class_install_properties (gobject_class,
    ///                                      G_N_ELEMENTS (obj_properties),
    ///                                      obj_properties);
    /// }
    /// ```
    ///
    /// allows calling `gobject.Object.notifyByPspec` to notify of property changes:
    ///
    /// ```
    /// void
    /// my_object_set_foo (MyObject *self, gint foo)
    /// {
    ///   if (self->foo != foo)
    ///     {
    ///       self->foo = foo;
    ///       g_object_notify_by_pspec (G_OBJECT (self), obj_properties[PROP_FOO]);
    ///     }
    ///  }
    /// ```
    extern fn g_object_class_install_properties(p_oclass: *ObjectClass, p_n_pspecs: c_uint, p_pspecs: [*]*gobject.ParamSpec) void;
    pub const installProperties = g_object_class_install_properties;

    /// Installs a new property.
    ///
    /// All properties should be installed during the class initializer.  It
    /// is possible to install properties after that, but doing so is not
    /// recommend, and specifically, is not guaranteed to be thread-safe vs.
    /// use of properties on the same type on other threads.
    ///
    /// Note that it is possible to redefine a property in a derived class,
    /// by installing a property with the same name. This can be useful at times,
    /// e.g. to change the range of allowed values or the default value.
    extern fn g_object_class_install_property(p_oclass: *ObjectClass, p_property_id: c_uint, p_pspec: *gobject.ParamSpec) void;
    pub const installProperty = g_object_class_install_property;

    /// Get an array of `gobject.ParamSpec`* for all properties of a class.
    extern fn g_object_class_list_properties(p_oclass: *ObjectClass, p_n_properties: *c_uint) [*]*gobject.ParamSpec;
    pub const listProperties = g_object_class_list_properties;

    /// Registers `property_id` as referring to a property with the name
    /// `name` in a parent class or in an interface implemented by `oclass`.
    /// This allows this class to "override" a property implementation in
    /// a parent class or to provide the implementation of a property from
    /// an interface.
    ///
    /// Internally, overriding is implemented by creating a property of type
    /// `gobject.ParamSpecOverride`; generally operations that query the properties of
    /// the object class, such as `gobject.ObjectClass.findProperty` or
    /// `gobject.ObjectClass.listProperties` will return the overridden
    /// property. However, in one case, the `construct_properties` argument of
    /// the `constructor` virtual function, the `gobject.ParamSpecOverride` is passed
    /// instead, so that the `param_id` field of the `gobject.ParamSpec` will be
    /// correct.  For virtually all uses, this makes no difference. If you
    /// need to get the overridden property, you can call
    /// `gobject.ParamSpec.getRedirectTarget`.
    extern fn g_object_class_override_property(p_oclass: *ObjectClass, p_property_id: c_uint, p_name: [*:0]const u8) void;
    pub const overrideProperty = g_object_class_override_property;

    pub fn as(p_instance: *ObjectClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The GObjectConstructParam struct is an auxiliary structure used to hand
/// `gobject.ParamSpec`/`gobject.Value` pairs to the `constructor` of a `gobject.ObjectClass`.
pub const ObjectConstructParam = extern struct {
    /// the `gobject.ParamSpec` of the construct parameter
    f_pspec: ?*gobject.ParamSpec,
    /// the value to set the parameter to
    f_value: ?*gobject.Value,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The class structure for the GParamSpec type.
/// Normally, GParamSpec classes are filled by
/// `gobject.paramTypeRegisterStatic`.
pub const ParamSpecClass = extern struct {
    pub const Instance = gobject.ParamSpec;

    /// the parent class
    f_g_type_class: gobject.TypeClass,
    /// the `gobject.Value` type for this parameter
    f_value_type: usize,
    /// The instance finalization function (optional), should chain
    ///  up to the finalize method of the parent class.
    f_finalize: ?*const fn (p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// Resets a `value` to the default value for this type
    ///  (recommended, the default is `gobject.Value.reset`), see
    ///  `gobject.paramValueSetDefault`.
    f_value_set_default: ?*const fn (p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) callconv(.c) void,
    /// Ensures that the contents of `value` comply with the
    ///  specifications set out by this type (optional), see
    ///  `gobject.paramValueValidate`.
    f_value_validate: ?*const fn (p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) callconv(.c) c_int,
    /// Compares `value1` with `value2` according to this type
    ///  (recommended, the default is `memcmp`), see `gobject.paramValuesCmp`.
    f_values_cmp: ?*const fn (p_pspec: *gobject.ParamSpec, p_value1: *const gobject.Value, p_value2: *const gobject.Value) callconv(.c) c_int,
    /// Checks if contents of `value` comply with the specifications
    ///   set out by this type, without modifying the value. This vfunc is optional.
    ///   If it isn't set, GObject will use `value_validate`. Since 2.74
    f_value_is_valid: ?*const fn (p_pspec: *gobject.ParamSpec, p_value: *const gobject.Value) callconv(.c) c_int,
    f_dummy: [3]*anyopaque,

    pub fn as(p_instance: *ParamSpecClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `gobject.ParamSpecPool` maintains a collection of `GParamSpecs` which can be
/// quickly accessed by owner and name.
///
/// The implementation of the `gobject.Object` property system uses such a pool to
/// store the `GParamSpecs` of the properties all object types.
pub const ParamSpecPool = opaque {
    /// Creates a new `gobject.ParamSpecPool`.
    ///
    /// If `type_prefixing` is `TRUE`, lookups in the newly created pool will
    /// allow to specify the owner as a colon-separated prefix of the
    /// property name, like "GtkContainer:border-width". This feature is
    /// deprecated, so you should always set `type_prefixing` to `FALSE`.
    extern fn g_param_spec_pool_new(p_type_prefixing: c_int) *gobject.ParamSpecPool;
    pub const new = g_param_spec_pool_new;

    /// Frees the resources allocated by a `gobject.ParamSpecPool`.
    extern fn g_param_spec_pool_free(p_pool: *ParamSpecPool) void;
    pub const free = g_param_spec_pool_free;

    /// Inserts a `gobject.ParamSpec` in the pool.
    extern fn g_param_spec_pool_insert(p_pool: *ParamSpecPool, p_pspec: *gobject.ParamSpec, p_owner_type: usize) void;
    pub const insert = g_param_spec_pool_insert;

    /// Gets an array of all `GParamSpecs` owned by `owner_type` in
    /// the pool.
    extern fn g_param_spec_pool_list(p_pool: *ParamSpecPool, p_owner_type: usize, p_n_pspecs_p: *c_uint) [*]*gobject.ParamSpec;
    pub const list = g_param_spec_pool_list;

    /// Gets an `glib.List` of all `GParamSpecs` owned by `owner_type` in
    /// the pool.
    extern fn g_param_spec_pool_list_owned(p_pool: *ParamSpecPool, p_owner_type: usize) *glib.List;
    pub const listOwned = g_param_spec_pool_list_owned;

    /// Looks up a `gobject.ParamSpec` in the pool.
    extern fn g_param_spec_pool_lookup(p_pool: *ParamSpecPool, p_param_name: [*:0]const u8, p_owner_type: usize, p_walk_ancestors: c_int) ?*gobject.ParamSpec;
    pub const lookup = g_param_spec_pool_lookup;

    /// Removes a `gobject.ParamSpec` from the pool.
    extern fn g_param_spec_pool_remove(p_pool: *ParamSpecPool, p_pspec: *gobject.ParamSpec) void;
    pub const remove = g_param_spec_pool_remove;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// This structure is used to provide the type system with the information
/// required to initialize and destruct (finalize) a parameter's class and
/// instances thereof.
///
/// The initialized structure is passed to the `gobject.paramTypeRegisterStatic`
/// The type system will perform a deep copy of this structure, so its memory
/// does not need to be persistent across invocation of
/// `gobject.paramTypeRegisterStatic`.
pub const ParamSpecTypeInfo = extern struct {
    /// Size of the instance (object) structure.
    f_instance_size: u16,
    /// Prior to GLib 2.10, it specified the number of pre-allocated (cached) instances to reserve memory for (0 indicates no caching). Since GLib 2.10, it is ignored, since instances are allocated with the [slice allocator][glib-Memory-Slices] now.
    f_n_preallocs: u16,
    /// Location of the instance initialization function (optional).
    f_instance_init: ?*const fn (p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// The `gobject.Type` of values conforming to this `gobject.ParamSpec`
    f_value_type: usize,
    /// The instance finalization function (optional).
    f_finalize: ?*const fn (p_pspec: *gobject.ParamSpec) callconv(.c) void,
    /// Resets a `value` to the default value for `pspec`
    ///  (recommended, the default is `gobject.Value.reset`), see
    ///  `gobject.paramValueSetDefault`.
    f_value_set_default: ?*const fn (p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) callconv(.c) void,
    /// Ensures that the contents of `value` comply with the
    ///  specifications set out by `pspec` (optional), see
    ///  `gobject.paramValueValidate`.
    f_value_validate: ?*const fn (p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) callconv(.c) c_int,
    /// Compares `value1` with `value2` according to `pspec`
    ///  (recommended, the default is `memcmp`), see `gobject.paramValuesCmp`.
    f_values_cmp: ?*const fn (p_pspec: *gobject.ParamSpec, p_value1: *const gobject.Value, p_value2: *const gobject.Value) callconv(.c) c_int,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The GParameter struct is an auxiliary structure used
/// to hand parameter name/value pairs to `gobject.Object.newv`.
pub const Parameter = extern struct {
    /// the parameter name
    f_name: ?[*:0]const u8,
    /// the parameter value
    f_value: gobject.Value,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The `gobject.SignalInvocationHint` structure is used to pass on additional information
/// to callbacks during a signal emission.
pub const SignalInvocationHint = extern struct {
    /// The signal id of the signal invoking the callback
    f_signal_id: c_uint,
    /// The detail passed on for this emission
    f_detail: glib.Quark,
    /// The stage the signal emission is currently in, this
    ///  field will contain one of `G_SIGNAL_RUN_FIRST`,
    ///  `G_SIGNAL_RUN_LAST` or `G_SIGNAL_RUN_CLEANUP` and `G_SIGNAL_ACCUMULATOR_FIRST_RUN`.
    ///  `G_SIGNAL_ACCUMULATOR_FIRST_RUN` is only set for the first run of the accumulator
    ///  function for a signal emission.
    f_run_type: gobject.SignalFlags,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure holding in-depth information for a specific signal.
///
/// See also: `gobject.signalQuery`
pub const SignalQuery = extern struct {
    /// The signal id of the signal being queried, or 0 if the
    ///  signal to be queried was unknown.
    f_signal_id: c_uint,
    /// The signal name.
    f_signal_name: ?[*:0]const u8,
    /// The interface/instance type that this signal can be emitted for.
    f_itype: usize,
    /// The signal flags as passed in to `gobject.signalNew`.
    f_signal_flags: gobject.SignalFlags,
    /// The return type for user callbacks.
    f_return_type: usize,
    /// The number of parameters that user callbacks take.
    f_n_params: c_uint,
    /// The individual parameter types for
    ///  user callbacks, note that the effective callback signature is:
    /// ```
    ///  `return_type` callback (`gpointer`     data1,
    ///  [param_types param_names,]
    ///  gpointer     data2);
    /// ```
    f_param_types: ?[*]const usize,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An opaque structure used as the base of all classes.
pub const TypeClass = extern struct {
    f_g_type: usize,

    extern fn g_type_class_adjust_private_offset(p_g_class: ?*anyopaque, p_private_size_or_offset: *c_int) void;
    pub const adjustPrivateOffset = g_type_class_adjust_private_offset;

    /// Retrieves the type class of the given `type`.
    ///
    /// This function will create the class on demand if it does not exist
    /// already.
    ///
    /// If you don't want to create the class, use `gobject.typeClassPeek` instead.
    extern fn g_type_class_get(p_type: usize) *gobject.TypeClass;
    pub const get = g_type_class_get;

    /// Retrieves the class for a give type.
    ///
    /// This function is essentially the same as `gobject.typeClassGet`,
    /// except that the class may have not been instantiated yet.
    ///
    /// As a consequence, this function may return `NULL` if the class
    /// of the type passed in does not currently exist (hasn't been
    /// referenced before).
    extern fn g_type_class_peek(p_type: usize) ?*gobject.TypeClass;
    pub const peek = g_type_class_peek;

    /// A more efficient version of `gobject.typeClassPeek` which works only for
    /// static types.
    extern fn g_type_class_peek_static(p_type: usize) ?*gobject.TypeClass;
    pub const peekStatic = g_type_class_peek_static;

    /// Increments the reference count of the class structure belonging to
    /// `type`.
    ///
    /// This function will demand-create the class if it doesn't exist already.
    extern fn g_type_class_ref(p_type: usize) *gobject.TypeClass;
    pub const ref = g_type_class_ref;

    /// Registers a private structure for an instantiatable type.
    ///
    /// When an object is allocated, the private structures for
    /// the type and all of its parent types are allocated
    /// sequentially in the same memory block as the public
    /// structures, and are zero-filled.
    ///
    /// Note that the accumulated size of the private structures of
    /// a type and all its parent types cannot exceed 64 KiB.
    ///
    /// This function should be called in the type's `class_init` function.
    /// The private structure can be retrieved using the
    /// `G_TYPE_INSTANCE_GET_PRIVATE` macro.
    ///
    /// The following example shows attaching a private structure
    /// MyObjectPrivate to an object MyObject defined in the standard
    /// GObject fashion in the type's `class_init` function.
    ///
    /// Note the use of a structure member "priv" to avoid the overhead
    /// of repeatedly calling `MY_OBJECT_GET_PRIVATE`.
    ///
    /// ```
    /// typedef struct _MyObject        MyObject;
    /// typedef struct _MyObjectPrivate MyObjectPrivate;
    ///
    /// struct _MyObject {
    ///  GObject parent;
    ///
    ///  MyObjectPrivate *priv;
    /// };
    ///
    /// struct _MyObjectPrivate {
    ///   int some_field;
    /// };
    ///
    /// static void
    /// my_object_class_init (MyObjectClass *klass)
    /// {
    ///   g_type_class_add_private (klass, sizeof (MyObjectPrivate));
    /// }
    ///
    /// static void
    /// my_object_init (MyObject *my_object)
    /// {
    ///   my_object->priv = G_TYPE_INSTANCE_GET_PRIVATE (my_object,
    ///                                                  MY_TYPE_OBJECT,
    ///                                                  MyObjectPrivate);
    ///   // my_object->priv->some_field will be automatically initialised to 0
    /// }
    ///
    /// static int
    /// my_object_get_some_field (MyObject *my_object)
    /// {
    ///   MyObjectPrivate *priv;
    ///
    ///   g_return_val_if_fail (MY_IS_OBJECT (my_object), 0);
    ///
    ///   priv = my_object->priv;
    ///
    ///   return priv->some_field;
    /// }
    /// ```
    extern fn g_type_class_add_private(p_g_class: *TypeClass, p_private_size: usize) void;
    pub const addPrivate = g_type_class_add_private;

    /// Gets the offset of the private data for instances of `g_class`.
    ///
    /// This is how many bytes you should add to the instance pointer of a
    /// class in order to get the private data for the type represented by
    /// `g_class`.
    ///
    /// You can only call this function after you have registered a private
    /// data area for `g_class` using `gobject.TypeClass.addPrivate`.
    extern fn g_type_class_get_instance_private_offset(p_g_class: *TypeClass) c_int;
    pub const getInstancePrivateOffset = g_type_class_get_instance_private_offset;

    extern fn g_type_class_get_private(p_klass: *TypeClass, p_private_type: usize) ?*anyopaque;
    pub const getPrivate = g_type_class_get_private;

    /// Retrieves the class structure of the immediate parent type of the
    /// class passed in.
    ///
    /// This is a convenience function often needed in class initializers.
    ///
    /// Since derived classes hold a reference on their parent classes as
    /// long as they are instantiated, the returned class will always exist.
    ///
    /// This function is essentially equivalent to:
    /// g_type_class_peek (g_type_parent (G_TYPE_FROM_CLASS (g_class)))
    extern fn g_type_class_peek_parent(p_g_class: *TypeClass) *gobject.TypeClass;
    pub const peekParent = g_type_class_peek_parent;

    /// Decrements the reference count of the class structure being passed in.
    ///
    /// Once the last reference count of a class has been released, classes
    /// may be finalized by the type system, so further dereferencing of a
    /// class pointer after `gobject.TypeClass.unref` are invalid.
    extern fn g_type_class_unref(p_g_class: *TypeClass) void;
    pub const unref = g_type_class_unref;

    /// A variant of `gobject.TypeClass.unref` for use in `gobject.TypeClassCacheFunc`
    /// implementations.
    ///
    /// It unreferences a class without consulting the chain
    /// of `GTypeClassCacheFuncs`, avoiding the recursion which would occur
    /// otherwise.
    extern fn g_type_class_unref_uncached(p_g_class: *TypeClass) void;
    pub const unrefUncached = g_type_class_unref_uncached;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure that provides information to the type system which is
/// used specifically for managing fundamental types.
pub const TypeFundamentalInfo = extern struct {
    /// `gobject.TypeFundamentalFlags` describing the characteristics of the fundamental type
    f_type_flags: gobject.TypeFundamentalFlags,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// This structure is used to provide the type system with the information
/// required to initialize and destruct (finalize) a type's class and
/// its instances.
///
/// The initialized structure is passed to the `gobject.typeRegisterStatic` function
/// (or is copied into the provided `gobject.TypeInfo` structure in the
/// `gobject.TypePlugin.completeTypeInfo`). The type system will perform a deep
/// copy of this structure, so its memory does not need to be persistent
/// across invocation of `gobject.typeRegisterStatic`.
pub const TypeInfo = extern struct {
    /// Size of the class structure (required for interface, classed and instantiatable types)
    f_class_size: u16,
    /// Location of the base initialization function (optional)
    f_base_init: ?gobject.BaseInitFunc,
    /// Location of the base finalization function (optional)
    f_base_finalize: ?gobject.BaseFinalizeFunc,
    /// Location of the class initialization function for
    ///  classed and instantiatable types. Location of the default vtable
    ///  initialization function for interface types. (optional) This function
    ///  is used both to fill in virtual functions in the class or default vtable,
    ///  and to do type-specific setup such as registering signals and object
    ///  properties.
    f_class_init: ?gobject.ClassInitFunc,
    /// Location of the class finalization function for
    ///  classed and instantiatable types. Location of the default vtable
    ///  finalization function for interface types. (optional)
    f_class_finalize: ?gobject.ClassFinalizeFunc,
    /// User-supplied data passed to the class init/finalize functions
    f_class_data: ?*const anyopaque,
    /// Size of the instance (object) structure (required for instantiatable types only)
    f_instance_size: u16,
    /// Prior to GLib 2.10, it specified the number of pre-allocated (cached) instances to reserve memory for (0 indicates no caching). Since GLib 2.10 this field is ignored.
    f_n_preallocs: u16,
    /// Location of the instance initialization function (optional, for instantiatable types only)
    f_instance_init: ?gobject.InstanceInitFunc,
    /// A `gobject.TypeValueTable` function table for generic handling of GValues
    ///  of this type (usually only useful for fundamental types)
    f_value_table: ?*const gobject.TypeValueTable,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An opaque structure used as the base of all type instances.
pub const TypeInstance = extern struct {
    f_g_class: ?*gobject.TypeClass,

    extern fn g_type_instance_get_private(p_instance: *TypeInstance, p_private_type: usize) ?*anyopaque;
    pub const getPrivate = g_type_instance_get_private;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An opaque structure used as the base of all interface types.
pub const TypeInterface = extern struct {
    f_g_type: usize,
    f_g_instance_type: usize,

    /// Adds `prerequisite_type` to the list of prerequisites of `interface_type`.
    /// This means that any type implementing `interface_type` must also implement
    /// `prerequisite_type`. Prerequisites can be thought of as an alternative to
    /// interface derivation (which GType doesn't support). An interface can have
    /// at most one instantiatable prerequisite type.
    extern fn g_type_interface_add_prerequisite(p_interface_type: usize, p_prerequisite_type: usize) void;
    pub const addPrerequisite = g_type_interface_add_prerequisite;

    /// Returns the `gobject.TypePlugin` structure for the dynamic interface
    /// `interface_type` which has been added to `instance_type`, or `NULL`
    /// if `interface_type` has not been added to `instance_type` or does
    /// not have a `gobject.TypePlugin` structure. See `gobject.typeAddInterfaceDynamic`.
    extern fn g_type_interface_get_plugin(p_instance_type: usize, p_interface_type: usize) *gobject.TypePlugin;
    pub const getPlugin = g_type_interface_get_plugin;

    /// Returns the most specific instantiatable prerequisite of an
    /// interface type. If the interface type has no instantiatable
    /// prerequisite, `G_TYPE_INVALID` is returned.
    ///
    /// See `gobject.typeInterfaceAddPrerequisite` for more information
    /// about prerequisites.
    extern fn g_type_interface_instantiatable_prerequisite(p_interface_type: usize) usize;
    pub const instantiatablePrerequisite = g_type_interface_instantiatable_prerequisite;

    /// Returns the `gobject.TypeInterface` structure of an interface to which the
    /// passed in class conforms.
    extern fn g_type_interface_peek(p_instance_class: *gobject.TypeClass, p_iface_type: usize) ?*gobject.TypeInterface;
    pub const peek = g_type_interface_peek;

    /// Returns the prerequisites of an interfaces type.
    extern fn g_type_interface_prerequisites(p_interface_type: usize, p_n_prerequisites: ?*c_uint) [*]usize;
    pub const prerequisites = g_type_interface_prerequisites;

    /// Returns the corresponding `gobject.TypeInterface` structure of the parent type
    /// of the instance type to which `g_iface` belongs.
    ///
    /// This is useful when deriving the implementation of an interface from the
    /// parent type and then possibly overriding some methods.
    extern fn g_type_interface_peek_parent(p_g_iface: *TypeInterface) ?*gobject.TypeInterface;
    pub const peekParent = g_type_interface_peek_parent;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// In order to implement dynamic loading of types based on `gobject.TypeModule`,
/// the `load` and `unload` functions in `gobject.TypeModuleClass` must be implemented.
pub const TypeModuleClass = extern struct {
    pub const Instance = gobject.TypeModule;

    /// the parent class
    f_parent_class: gobject.ObjectClass,
    /// loads the module and registers one or more types using
    ///  `gobject.TypeModule.registerType`.
    f_load: ?*const fn (p_module: *gobject.TypeModule) callconv(.c) c_int,
    /// unloads the module
    f_unload: ?*const fn (p_module: *gobject.TypeModule) callconv(.c) void,
    f_reserved1: ?*const fn () callconv(.c) void,
    f_reserved2: ?*const fn () callconv(.c) void,
    f_reserved3: ?*const fn () callconv(.c) void,
    f_reserved4: ?*const fn () callconv(.c) void,

    pub fn as(p_instance: *TypeModuleClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The `gobject.TypePlugin` interface is used by the type system in order to handle
/// the lifecycle of dynamically loaded types.
pub const TypePluginClass = extern struct {
    f_base_iface: gobject.TypeInterface,
    /// Increases the use count of the plugin.
    f_use_plugin: ?gobject.TypePluginUse,
    /// Decreases the use count of the plugin.
    f_unuse_plugin: ?gobject.TypePluginUnuse,
    /// Fills in the `gobject.TypeInfo` and
    ///  `gobject.TypeValueTable` structs for the type. The structs are initialized
    ///  with `memset(s, 0, sizeof (s))` before calling this function.
    f_complete_type_info: ?gobject.TypePluginCompleteTypeInfo,
    /// Fills in missing parts of the `gobject.InterfaceInfo`
    ///  for the interface. The structs is initialized with
    ///  `memset(s, 0, sizeof (s))` before calling this function.
    f_complete_interface_info: ?gobject.TypePluginCompleteInterfaceInfo,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure holding information for a specific type.
///
/// See also: `gobject.typeQuery`
pub const TypeQuery = extern struct {
    /// the `gobject.Type` value of the type
    f_type: usize,
    /// the name of the type
    f_type_name: ?[*:0]const u8,
    /// the size of the class structure
    f_class_size: c_uint,
    /// the size of the instance structure
    f_instance_size: c_uint,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// - `'i'`: Integers, passed as `collect_values[].v_int`
///   - `'l'`: Longs, passed as `collect_values[].v_long`
///   - `'d'`: Doubles, passed as `collect_values[].v_double`
///   - `'p'`: Pointers, passed as `collect_values[].v_pointer`
///
///   It should be noted that for variable argument list construction,
///   ANSI C promotes every type smaller than an integer to an int, and
///   floats to doubles. So for collection of short int or char, `'i'`
///   needs to be used, and for collection of floats `'d'`.
/// The `gobject.TypeValueTable` provides the functions required by the `gobject.Value`
/// implementation, to serve as a container for values of a type.
pub const TypeValueTable = extern struct {
    /// Function to initialize a GValue
    f_value_init: ?gobject.TypeValueInitFunc,
    /// Function to free a GValue
    f_value_free: ?gobject.TypeValueFreeFunc,
    /// Function to copy a GValue
    f_value_copy: ?gobject.TypeValueCopyFunc,
    /// Function to peek the contents of a GValue if they fit
    ///   into a pointer
    f_value_peek_pointer: ?gobject.TypeValuePeekPointerFunc,
    /// A string format describing how to collect the contents of
    ///   this value bit-by-bit. Each character in the format represents
    ///   an argument to be collected, and the characters themselves indicate
    ///   the type of the argument. Currently supported arguments are:
    f_collect_format: ?[*:0]const u8,
    /// Function to initialize a GValue from the values
    ///   collected from variadic arguments
    f_collect_value: ?gobject.TypeValueCollectFunc,
    /// Format description of the arguments to collect for `lcopy_value`,
    ///   analogous to `collect_format`. Usually, `lcopy_format` string consists
    ///   only of `'p'`s to provide `lcopy_value` with pointers to storage locations.
    f_lcopy_format: ?[*:0]const u8,
    /// Function to store the contents of a value into the
    ///   locations collected from variadic arguments
    f_lcopy_value: ?gobject.TypeValueLCopyFunc,

    /// Returns the location of the `gobject.TypeValueTable` associated with `type`.
    ///
    /// Note that this function should only be used from source code
    /// that implements or has internal knowledge of the implementation of
    /// `type`.
    extern fn g_type_value_table_peek(p_type: usize) ?*gobject.TypeValueTable;
    pub const peek = g_type_value_table_peek;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An opaque structure used to hold different types of values.
///
/// The data within the structure has protected scope: it is accessible only
/// to functions within a `gobject.TypeValueTable` structure, or implementations of
/// the g_value_*() API. That is, code portions which implement new fundamental
/// types.
///
/// `gobject.Value` users cannot make any assumptions about how data is stored
/// within the 2 element `data` union, and the `g_type` member should
/// only be accessed through the `G_VALUE_TYPE` macro.
pub const Value = extern struct {
    f_g_type: usize,
    f_data: [2]gobject._Value__data__union,

    /// Registers a value transformation function for use in `gobject.Value.transform`.
    /// A previously registered transformation function for `src_type` and `dest_type`
    /// will be replaced.
    extern fn g_value_register_transform_func(p_src_type: usize, p_dest_type: usize, p_transform_func: gobject.ValueTransform) void;
    pub const registerTransformFunc = g_value_register_transform_func;

    /// Returns whether a `gobject.Value` of type `src_type` can be copied into
    /// a `gobject.Value` of type `dest_type`.
    extern fn g_value_type_compatible(p_src_type: usize, p_dest_type: usize) c_int;
    pub const typeCompatible = g_value_type_compatible;

    /// Check whether `gobject.Value.transform` is able to transform values
    /// of type `src_type` into values of type `dest_type`. Note that for
    /// the types to be transformable, they must be compatible or a
    /// transformation function must be registered.
    extern fn g_value_type_transformable(p_src_type: usize, p_dest_type: usize) c_int;
    pub const typeTransformable = g_value_type_transformable;

    /// Copies the value of `src_value` into `dest_value`.
    extern fn g_value_copy(p_src_value: *const Value, p_dest_value: *gobject.Value) void;
    pub const copy = g_value_copy;

    /// Get the contents of a `G_TYPE_BOXED` derived `gobject.Value`.  Upon getting,
    /// the boxed value is duplicated and needs to be later freed with
    /// `gobject.boxedFree`, e.g. like: g_boxed_free (G_VALUE_TYPE (`value`),
    /// return_value);
    extern fn g_value_dup_boxed(p_value: *const Value) ?*anyopaque;
    pub const dupBoxed = g_value_dup_boxed;

    /// Get the contents of a `G_TYPE_OBJECT` derived `gobject.Value`, increasing
    /// its reference count. If the contents of the `gobject.Value` are `NULL`, then
    /// `NULL` will be returned.
    extern fn g_value_dup_object(p_value: *const Value) ?*gobject.Object;
    pub const dupObject = g_value_dup_object;

    /// Get the contents of a `G_TYPE_PARAM` `gobject.Value`, increasing its
    /// reference count.
    extern fn g_value_dup_param(p_value: *const Value) *gobject.ParamSpec;
    pub const dupParam = g_value_dup_param;

    /// Get a copy the contents of a `G_TYPE_STRING` `gobject.Value`.
    extern fn g_value_dup_string(p_value: *const Value) ?[*:0]u8;
    pub const dupString = g_value_dup_string;

    /// Get the contents of a variant `gobject.Value`, increasing its refcount. The returned
    /// `glib.Variant` is never floating.
    extern fn g_value_dup_variant(p_value: *const Value) ?*glib.Variant;
    pub const dupVariant = g_value_dup_variant;

    /// Determines if `value` will fit inside the size of a pointer value.
    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_fits_pointer(p_value: *const Value) c_int;
    pub const fitsPointer = g_value_fits_pointer;

    /// Get the contents of a `G_TYPE_BOOLEAN` `gobject.Value`.
    extern fn g_value_get_boolean(p_value: *const Value) c_int;
    pub const getBoolean = g_value_get_boolean;

    /// Get the contents of a `G_TYPE_BOXED` derived `gobject.Value`.
    extern fn g_value_get_boxed(p_value: *const Value) ?*anyopaque;
    pub const getBoxed = g_value_get_boxed;

    /// Do not use this function; it is broken on platforms where the `char`
    /// type is unsigned, such as ARM and PowerPC.  See `gobject.Value.getSchar`.
    ///
    /// Get the contents of a `G_TYPE_CHAR` `gobject.Value`.
    extern fn g_value_get_char(p_value: *const Value) u8;
    pub const getChar = g_value_get_char;

    /// Get the contents of a `G_TYPE_DOUBLE` `gobject.Value`.
    extern fn g_value_get_double(p_value: *const Value) f64;
    pub const getDouble = g_value_get_double;

    /// Get the contents of a `G_TYPE_ENUM` `gobject.Value`.
    extern fn g_value_get_enum(p_value: *const Value) c_int;
    pub const getEnum = g_value_get_enum;

    /// Get the contents of a `G_TYPE_FLAGS` `gobject.Value`.
    extern fn g_value_get_flags(p_value: *const Value) c_uint;
    pub const getFlags = g_value_get_flags;

    /// Get the contents of a `G_TYPE_FLOAT` `gobject.Value`.
    extern fn g_value_get_float(p_value: *const Value) f32;
    pub const getFloat = g_value_get_float;

    /// Get the contents of a `G_TYPE_GTYPE` `gobject.Value`.
    extern fn g_value_get_gtype(p_value: *const Value) usize;
    pub const getGtype = g_value_get_gtype;

    /// Get the contents of a `G_TYPE_INT` `gobject.Value`.
    extern fn g_value_get_int(p_value: *const Value) c_int;
    pub const getInt = g_value_get_int;

    /// Get the contents of a `G_TYPE_INT64` `gobject.Value`.
    extern fn g_value_get_int64(p_value: *const Value) i64;
    pub const getInt64 = g_value_get_int64;

    /// Get the contents of a `G_TYPE_LONG` `gobject.Value`.
    extern fn g_value_get_long(p_value: *const Value) c_long;
    pub const getLong = g_value_get_long;

    /// Get the contents of a `G_TYPE_OBJECT` derived `gobject.Value`.
    extern fn g_value_get_object(p_value: *const Value) ?*gobject.Object;
    pub const getObject = g_value_get_object;

    /// Get the contents of a `G_TYPE_PARAM` `gobject.Value`.
    extern fn g_value_get_param(p_value: *const Value) *gobject.ParamSpec;
    pub const getParam = g_value_get_param;

    /// Get the contents of a pointer `gobject.Value`.
    extern fn g_value_get_pointer(p_value: *const Value) ?*anyopaque;
    pub const getPointer = g_value_get_pointer;

    /// Get the contents of a `G_TYPE_CHAR` `gobject.Value`.
    extern fn g_value_get_schar(p_value: *const Value) i8;
    pub const getSchar = g_value_get_schar;

    /// Get the contents of a `G_TYPE_STRING` `gobject.Value`.
    extern fn g_value_get_string(p_value: *const Value) ?[*:0]const u8;
    pub const getString = g_value_get_string;

    /// Get the contents of a `G_TYPE_UCHAR` `gobject.Value`.
    extern fn g_value_get_uchar(p_value: *const Value) u8;
    pub const getUchar = g_value_get_uchar;

    /// Get the contents of a `G_TYPE_UINT` `gobject.Value`.
    extern fn g_value_get_uint(p_value: *const Value) c_uint;
    pub const getUint = g_value_get_uint;

    /// Get the contents of a `G_TYPE_UINT64` `gobject.Value`.
    extern fn g_value_get_uint64(p_value: *const Value) u64;
    pub const getUint64 = g_value_get_uint64;

    /// Get the contents of a `G_TYPE_ULONG` `gobject.Value`.
    extern fn g_value_get_ulong(p_value: *const Value) c_ulong;
    pub const getUlong = g_value_get_ulong;

    /// Get the contents of a variant `gobject.Value`.
    extern fn g_value_get_variant(p_value: *const Value) ?*glib.Variant;
    pub const getVariant = g_value_get_variant;

    /// Initializes `value` with the default value of `type`.
    extern fn g_value_init(p_value: *Value, p_g_type: usize) *gobject.Value;
    pub const init = g_value_init;

    /// Initializes and sets `value` from an instantiatable type via the
    /// value_table's `collect_value` function.
    ///
    /// Note: The `value` will be initialised with the exact type of
    /// `instance`.  If you wish to set the `value`'s type to a different GType
    /// (such as a parent class GType), you need to manually call
    /// `gobject.Value.init` and `gobject.Value.setInstance`.
    extern fn g_value_init_from_instance(p_value: *Value, p_instance: *gobject.TypeInstance) void;
    pub const initFromInstance = g_value_init_from_instance;

    /// Returns the value contents as pointer. This function asserts that
    /// `gobject.Value.fitsPointer` returned `TRUE` for the passed in value.
    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_peek_pointer(p_value: *const Value) ?*anyopaque;
    pub const peekPointer = g_value_peek_pointer;

    /// Clears the current value in `value` and resets it to the default value
    /// (as if the value had just been initialized).
    extern fn g_value_reset(p_value: *Value) *gobject.Value;
    pub const reset = g_value_reset;

    /// Set the contents of a `G_TYPE_BOOLEAN` `gobject.Value` to `v_boolean`.
    extern fn g_value_set_boolean(p_value: *Value, p_v_boolean: c_int) void;
    pub const setBoolean = g_value_set_boolean;

    /// Set the contents of a `G_TYPE_BOXED` derived `gobject.Value` to `v_boxed`.
    extern fn g_value_set_boxed(p_value: *Value, p_v_boxed: ?*const anyopaque) void;
    pub const setBoxed = g_value_set_boxed;

    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_set_boxed_take_ownership(p_value: *Value, p_v_boxed: ?*const anyopaque) void;
    pub const setBoxedTakeOwnership = g_value_set_boxed_take_ownership;

    /// Set the contents of a `G_TYPE_CHAR` `gobject.Value` to `v_char`.
    extern fn g_value_set_char(p_value: *Value, p_v_char: u8) void;
    pub const setChar = g_value_set_char;

    /// Set the contents of a `G_TYPE_DOUBLE` `gobject.Value` to `v_double`.
    extern fn g_value_set_double(p_value: *Value, p_v_double: f64) void;
    pub const setDouble = g_value_set_double;

    /// Set the contents of a `G_TYPE_ENUM` `gobject.Value` to `v_enum`.
    extern fn g_value_set_enum(p_value: *Value, p_v_enum: c_int) void;
    pub const setEnum = g_value_set_enum;

    /// Set the contents of a `G_TYPE_FLAGS` `gobject.Value` to `v_flags`.
    extern fn g_value_set_flags(p_value: *Value, p_v_flags: c_uint) void;
    pub const setFlags = g_value_set_flags;

    /// Set the contents of a `G_TYPE_FLOAT` `gobject.Value` to `v_float`.
    extern fn g_value_set_float(p_value: *Value, p_v_float: f32) void;
    pub const setFloat = g_value_set_float;

    /// Set the contents of a `G_TYPE_GTYPE` `gobject.Value` to `v_gtype`.
    extern fn g_value_set_gtype(p_value: *Value, p_v_gtype: usize) void;
    pub const setGtype = g_value_set_gtype;

    /// Sets `value` from an instantiatable type via the
    /// value_table's `collect_value` function.
    extern fn g_value_set_instance(p_value: *Value, p_instance: ?*anyopaque) void;
    pub const setInstance = g_value_set_instance;

    /// Set the contents of a `G_TYPE_INT` `gobject.Value` to `v_int`.
    extern fn g_value_set_int(p_value: *Value, p_v_int: c_int) void;
    pub const setInt = g_value_set_int;

    /// Set the contents of a `G_TYPE_INT64` `gobject.Value` to `v_int64`.
    extern fn g_value_set_int64(p_value: *Value, p_v_int64: i64) void;
    pub const setInt64 = g_value_set_int64;

    /// Set the contents of a `G_TYPE_STRING` `gobject.Value` to `v_string`.  The string is
    /// assumed to be static and interned (canonical, for example from
    /// `glib.internString`), and is thus not duplicated when setting the `gobject.Value`.
    extern fn g_value_set_interned_string(p_value: *Value, p_v_string: ?[*:0]const u8) void;
    pub const setInternedString = g_value_set_interned_string;

    /// Set the contents of a `G_TYPE_LONG` `gobject.Value` to `v_long`.
    extern fn g_value_set_long(p_value: *Value, p_v_long: c_long) void;
    pub const setLong = g_value_set_long;

    /// Set the contents of a `G_TYPE_OBJECT` derived `gobject.Value` to `v_object`.
    ///
    /// `gobject.Value.setObject` increases the reference count of `v_object`
    /// (the `gobject.Value` holds a reference to `v_object`).  If you do not wish
    /// to increase the reference count of the object (i.e. you wish to
    /// pass your current reference to the `gobject.Value` because you no longer
    /// need it), use `gobject.Value.takeObject` instead.
    ///
    /// It is important that your `gobject.Value` holds a reference to `v_object` (either its
    /// own, or one it has taken) to ensure that the object won't be destroyed while
    /// the `gobject.Value` still exists).
    extern fn g_value_set_object(p_value: *Value, p_v_object: ?*gobject.Object) void;
    pub const setObject = g_value_set_object;

    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_set_object_take_ownership(p_value: *Value, p_v_object: ?*anyopaque) void;
    pub const setObjectTakeOwnership = g_value_set_object_take_ownership;

    /// Set the contents of a `G_TYPE_PARAM` `gobject.Value` to `param`.
    extern fn g_value_set_param(p_value: *Value, p_param: ?*gobject.ParamSpec) void;
    pub const setParam = g_value_set_param;

    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_set_param_take_ownership(p_value: *Value, p_param: ?*gobject.ParamSpec) void;
    pub const setParamTakeOwnership = g_value_set_param_take_ownership;

    /// Set the contents of a pointer `gobject.Value` to `v_pointer`.
    extern fn g_value_set_pointer(p_value: *Value, p_v_pointer: ?*anyopaque) void;
    pub const setPointer = g_value_set_pointer;

    /// Set the contents of a `G_TYPE_CHAR` `gobject.Value` to `v_char`.
    extern fn g_value_set_schar(p_value: *Value, p_v_char: i8) void;
    pub const setSchar = g_value_set_schar;

    /// Set the contents of a `G_TYPE_BOXED` derived `gobject.Value` to `v_boxed`.
    ///
    /// The boxed value is assumed to be static, and is thus not duplicated
    /// when setting the `gobject.Value`.
    extern fn g_value_set_static_boxed(p_value: *Value, p_v_boxed: ?*const anyopaque) void;
    pub const setStaticBoxed = g_value_set_static_boxed;

    /// Set the contents of a `G_TYPE_STRING` `gobject.Value` to `v_string`.
    /// The string is assumed to be static, and is thus not duplicated
    /// when setting the `gobject.Value`.
    ///
    /// If the the string is a canonical string, using `gobject.Value.setInternedString`
    /// is more appropriate.
    extern fn g_value_set_static_string(p_value: *Value, p_v_string: ?[*:0]const u8) void;
    pub const setStaticString = g_value_set_static_string;

    /// Set the contents of a `G_TYPE_STRING` `gobject.Value` to a copy of `v_string`.
    extern fn g_value_set_string(p_value: *Value, p_v_string: ?[*:0]const u8) void;
    pub const setString = g_value_set_string;

    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_set_string_take_ownership(p_value: *Value, p_v_string: ?[*:0]u8) void;
    pub const setStringTakeOwnership = g_value_set_string_take_ownership;

    /// Set the contents of a `G_TYPE_UCHAR` `gobject.Value` to `v_uchar`.
    extern fn g_value_set_uchar(p_value: *Value, p_v_uchar: u8) void;
    pub const setUchar = g_value_set_uchar;

    /// Set the contents of a `G_TYPE_UINT` `gobject.Value` to `v_uint`.
    extern fn g_value_set_uint(p_value: *Value, p_v_uint: c_uint) void;
    pub const setUint = g_value_set_uint;

    /// Set the contents of a `G_TYPE_UINT64` `gobject.Value` to `v_uint64`.
    extern fn g_value_set_uint64(p_value: *Value, p_v_uint64: u64) void;
    pub const setUint64 = g_value_set_uint64;

    /// Set the contents of a `G_TYPE_ULONG` `gobject.Value` to `v_ulong`.
    extern fn g_value_set_ulong(p_value: *Value, p_v_ulong: c_ulong) void;
    pub const setUlong = g_value_set_ulong;

    /// Set the contents of a variant `gobject.Value` to `variant`.
    /// If the variant is floating, it is consumed.
    extern fn g_value_set_variant(p_value: *Value, p_variant: ?*glib.Variant) void;
    pub const setVariant = g_value_set_variant;

    /// Steal ownership on contents of a `G_TYPE_STRING` `gobject.Value`.
    /// As a result of this operation the value's contents will be reset to `NULL`.
    ///
    /// The purpose of this call is to provide a way to avoid an extra copy
    /// when some object have been serialized into string through `gobject.Value` API.
    ///
    /// NOTE: for safety and compatibility purposes, if `gobject.Value` contains
    /// static string, or an interned one, this function will return a copy
    /// of the string. Otherwise the transfer notation would be ambiguous.
    extern fn g_value_steal_string(p_value: *Value) ?[*:0]u8;
    pub const stealString = g_value_steal_string;

    /// Sets the contents of a `G_TYPE_BOXED` derived `gobject.Value` to `v_boxed`
    /// and takes over the ownership of the caller’s reference to `v_boxed`;
    /// the caller doesn’t have to unref it any more.
    extern fn g_value_take_boxed(p_value: *Value, p_v_boxed: ?*const anyopaque) void;
    pub const takeBoxed = g_value_take_boxed;

    /// Sets the contents of a `G_TYPE_OBJECT` derived `gobject.Value` to `v_object`
    /// and takes over the ownership of the caller’s reference to `v_object`;
    /// the caller doesn’t have to unref it any more (i.e. the reference
    /// count of the object is not increased).
    ///
    /// If you want the `gobject.Value` to hold its own reference to `v_object`, use
    /// `gobject.Value.setObject` instead.
    extern fn g_value_take_object(p_value: *Value, p_v_object: ?*anyopaque) void;
    pub const takeObject = g_value_take_object;

    /// Sets the contents of a `G_TYPE_PARAM` `gobject.Value` to `param` and takes
    /// over the ownership of the caller’s reference to `param`; the caller
    /// doesn’t have to unref it any more.
    extern fn g_value_take_param(p_value: *Value, p_param: ?*gobject.ParamSpec) void;
    pub const takeParam = g_value_take_param;

    /// Sets the contents of a `G_TYPE_STRING` `gobject.Value` to `v_string`.
    extern fn g_value_take_string(p_value: *Value, p_v_string: ?[*:0]u8) void;
    pub const takeString = g_value_take_string;

    /// Set the contents of a variant `gobject.Value` to `variant`, and takes over
    /// the ownership of the caller's reference to `variant`;
    /// the caller doesn't have to unref it any more (i.e. the reference
    /// count of the variant is not increased).
    ///
    /// If `variant` was floating then its floating reference is converted to
    /// a hard reference.
    ///
    /// If you want the `gobject.Value` to hold its own reference to `variant`, use
    /// `gobject.Value.setVariant` instead.
    ///
    /// This is an internal function introduced mainly for C marshallers.
    extern fn g_value_take_variant(p_value: *Value, p_variant: ?*glib.Variant) void;
    pub const takeVariant = g_value_take_variant;

    /// Tries to cast the contents of `src_value` into a type appropriate
    /// to store in `dest_value`, e.g. to transform a `G_TYPE_INT` value
    /// into a `G_TYPE_FLOAT` value. Performing transformations between
    /// value types might incur precision lossage. Especially
    /// transformations into strings might reveal seemingly arbitrary
    /// results and shouldn't be relied upon for production code (such
    /// as rcfile value or object property serialization).
    extern fn g_value_transform(p_src_value: *const Value, p_dest_value: *gobject.Value) c_int;
    pub const transform = g_value_transform;

    /// Clears the current value in `value` (if any) and "unsets" the type,
    /// this releases all resources associated with this GValue. An unset
    /// value is the same as an uninitialized (zero-filled) `gobject.Value`
    /// structure.
    extern fn g_value_unset(p_value: *Value) void;
    pub const unset = g_value_unset;

    extern fn g_value_get_type() usize;
    pub const getGObjectType = g_value_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `GValueArray` is a container structure to hold an array of generic values.
///
/// The prime purpose of a `GValueArray` is for it to be used as an
/// object property that holds an array of values. A `GValueArray` wraps
/// an array of `GValue` elements in order for it to be used as a boxed
/// type through `G_TYPE_VALUE_ARRAY`.
///
/// `GValueArray` is deprecated in favour of `GArray` since GLib 2.32.
/// It is possible to create a `GArray` that behaves like a `GValueArray`
/// by using the size of `GValue` as the element size, and by setting
/// `gobject.Value.unset` as the clear function using
/// `glib.Array.setClearFunc`, for instance, the following code:
///
/// ```c
///   GValueArray *array = g_value_array_new (10);
/// ```
///
/// can be replaced by:
///
/// ```c
///   GArray *array = g_array_sized_new (FALSE, TRUE, sizeof (GValue), 10);
///   g_array_set_clear_func (array, (GDestroyNotify) g_value_unset);
/// ```
pub const ValueArray = extern struct {
    /// number of values contained in the array
    f_n_values: c_uint,
    /// array of values
    f_values: ?*gobject.Value,
    f_n_prealloced: c_uint,

    /// Allocate and initialize a new `gobject.ValueArray`, optionally preserve space
    /// for `n_prealloced` elements. New arrays always contain 0 elements,
    /// regardless of the value of `n_prealloced`.
    extern fn g_value_array_new(p_n_prealloced: c_uint) *gobject.ValueArray;
    pub const new = g_value_array_new;

    /// Insert a copy of `value` as last element of `value_array`. If `value` is
    /// `NULL`, an uninitialized value is appended.
    extern fn g_value_array_append(p_value_array: *ValueArray, p_value: ?*const gobject.Value) *gobject.ValueArray;
    pub const append = g_value_array_append;

    /// Construct an exact copy of a `gobject.ValueArray` by duplicating all its
    /// contents.
    extern fn g_value_array_copy(p_value_array: *const ValueArray) *gobject.ValueArray;
    pub const copy = g_value_array_copy;

    /// Free a `gobject.ValueArray` including its contents.
    extern fn g_value_array_free(p_value_array: *ValueArray) void;
    pub const free = g_value_array_free;

    /// Return a pointer to the value at `index_` contained in `value_array`.
    extern fn g_value_array_get_nth(p_value_array: *ValueArray, p_index_: c_uint) *gobject.Value;
    pub const getNth = g_value_array_get_nth;

    /// Insert a copy of `value` at specified position into `value_array`. If `value`
    /// is `NULL`, an uninitialized value is inserted.
    extern fn g_value_array_insert(p_value_array: *ValueArray, p_index_: c_uint, p_value: ?*const gobject.Value) *gobject.ValueArray;
    pub const insert = g_value_array_insert;

    /// Insert a copy of `value` as first element of `value_array`. If `value` is
    /// `NULL`, an uninitialized value is prepended.
    extern fn g_value_array_prepend(p_value_array: *ValueArray, p_value: ?*const gobject.Value) *gobject.ValueArray;
    pub const prepend = g_value_array_prepend;

    /// Remove the value at position `index_` from `value_array`.
    extern fn g_value_array_remove(p_value_array: *ValueArray, p_index_: c_uint) *gobject.ValueArray;
    pub const remove = g_value_array_remove;

    /// Sort `value_array` using `compare_func` to compare the elements according to
    /// the semantics of `glib.CompareFunc`.
    ///
    /// The current implementation uses the same sorting algorithm as standard
    /// C `qsort` function.
    extern fn g_value_array_sort(p_value_array: *ValueArray, p_compare_func: glib.CompareFunc) *gobject.ValueArray;
    pub const sort = g_value_array_sort;

    /// Sort `value_array` using `compare_func` to compare the elements according
    /// to the semantics of `glib.CompareDataFunc`.
    ///
    /// The current implementation uses the same sorting algorithm as standard
    /// C `qsort` function.
    extern fn g_value_array_sort_with_data(p_value_array: *ValueArray, p_compare_func: glib.CompareDataFunc, p_user_data: ?*anyopaque) *gobject.ValueArray;
    pub const sortWithData = g_value_array_sort_with_data;

    extern fn g_value_array_get_type() usize;
    pub const getGObjectType = g_value_array_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure containing a weak reference to a `gobject.Object`.
///
/// A `GWeakRef` can either be empty (i.e. point to `NULL`), or point to an
/// object for as long as at least one "strong" reference to that object
/// exists. Before the object's `gobject.ObjectClass.dispose` method is called,
/// every `gobject.WeakRef` associated with becomes empty (i.e. points to `NULL`).
///
/// Like `gobject.Value`, `gobject.WeakRef` can be statically allocated, stack- or
/// heap-allocated, or embedded in larger structures.
///
/// Unlike `gobject.Object.weakRef` and `gobject.Object.addWeakPointer`, this weak
/// reference is thread-safe: converting a weak pointer to a reference is
/// atomic with respect to invalidation of weak pointers to destroyed
/// objects.
///
/// If the object's `gobject.ObjectClass.dispose` method results in additional
/// references to the object being held (‘re-referencing’), any `GWeakRefs` taken
/// before it was disposed will continue to point to `NULL`.  Any `GWeakRefs` taken
/// during disposal and after re-referencing, or after disposal has returned due
/// to the re-referencing, will continue to point to the object until its refcount
/// goes back to zero, at which point they too will be invalidated.
///
/// It is invalid to take a `gobject.WeakRef` on an object during `gobject.ObjectClass.dispose`
/// without first having or creating a strong reference to the object.
pub const WeakRef = extern struct {
    anon0: extern union {
        f_p: ?*anyopaque,
    },

    /// Frees resources associated with a non-statically-allocated `gobject.WeakRef`.
    /// After this call, the `gobject.WeakRef` is left in an undefined state.
    ///
    /// You should only call this on a `gobject.WeakRef` that previously had
    /// `gobject.WeakRef.init` called on it.
    extern fn g_weak_ref_clear(p_weak_ref: *WeakRef) void;
    pub const clear = g_weak_ref_clear;

    /// If `weak_ref` is not empty, atomically acquire a strong
    /// reference to the object it points to, and return that reference.
    ///
    /// This function is needed because of the potential race between taking
    /// the pointer value and `gobject.Object.ref` on it, if the object was losing
    /// its last reference at the same time in a different thread.
    ///
    /// The caller should release the resulting reference in the usual way,
    /// by using `gobject.Object.unref`.
    extern fn g_weak_ref_get(p_weak_ref: *WeakRef) *gobject.Object;
    pub const get = g_weak_ref_get;

    /// Initialise a non-statically-allocated `gobject.WeakRef`.
    ///
    /// This function also calls `gobject.WeakRef.set` with `object` on the
    /// freshly-initialised weak reference.
    ///
    /// This function should always be matched with a call to
    /// `gobject.WeakRef.clear`.  It is not necessary to use this function for a
    /// `gobject.WeakRef` in static storage because it will already be
    /// properly initialised.  Just use `gobject.WeakRef.set` directly.
    extern fn g_weak_ref_init(p_weak_ref: *WeakRef, p_object: ?*gobject.Object) void;
    pub const init = g_weak_ref_init;

    /// Change the object to which `weak_ref` points, or set it to
    /// `NULL`.
    ///
    /// You must own a strong reference on `object` while calling this
    /// function.
    extern fn g_weak_ref_set(p_weak_ref: *WeakRef, p_object: ?*gobject.Object) void;
    pub const set = g_weak_ref_set;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A union holding one collected value.
pub const TypeCValue = extern union {
    /// the field for holding integer values
    f_v_int: c_int,
    /// the field for holding long integer values
    f_v_long: c_long,
    /// the field for holding 64 bit integer values
    f_v_int64: i64,
    /// the field for holding floating point values
    f_v_double: f64,
    /// the field for holding pointers
    f_v_pointer: ?*anyopaque,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const _Value__data__union = extern union {
    f_v_int: c_int,
    f_v_uint: c_uint,
    f_v_long: c_long,
    f_v_ulong: c_ulong,
    f_v_int64: i64,
    f_v_uint64: u64,
    f_v_float: f32,
    f_v_double: f64,
    f_v_pointer: ?*anyopaque,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Flags to be passed to `gobject.Object.bindProperty` or
/// `gobject.Object.bindPropertyFull`.
///
/// This enumeration can be extended at later date.
pub const BindingFlags = packed struct(c_uint) {
    bidirectional: bool = false,
    sync_create: bool = false,
    invert_boolean: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_default: BindingFlags = @bitCast(@as(c_uint, 0));
    pub const flags_bidirectional: BindingFlags = @bitCast(@as(c_uint, 1));
    pub const flags_sync_create: BindingFlags = @bitCast(@as(c_uint, 2));
    pub const flags_invert_boolean: BindingFlags = @bitCast(@as(c_uint, 4));
    extern fn g_binding_flags_get_type() usize;
    pub const getGObjectType = g_binding_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The connection flags are used to specify the behaviour of a signal's
/// connection.
pub const ConnectFlags = packed struct(c_uint) {
    after: bool = false,
    swapped: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_default: ConnectFlags = @bitCast(@as(c_uint, 0));
    pub const flags_after: ConnectFlags = @bitCast(@as(c_uint, 1));
    pub const flags_swapped: ConnectFlags = @bitCast(@as(c_uint, 2));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const IOCondition = packed struct(c_uint) {
    in: bool = false,
    pri: bool = false,
    out: bool = false,
    err: bool = false,
    hup: bool = false,
    nval: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_in: IOCondition = @bitCast(@as(c_uint, 1));
    pub const flags_out: IOCondition = @bitCast(@as(c_uint, 4));
    pub const flags_pri: IOCondition = @bitCast(@as(c_uint, 2));
    pub const flags_err: IOCondition = @bitCast(@as(c_uint, 8));
    pub const flags_hup: IOCondition = @bitCast(@as(c_uint, 16));
    pub const flags_nval: IOCondition = @bitCast(@as(c_uint, 32));
    extern fn g_io_condition_get_type() usize;
    pub const getGObjectType = g_io_condition_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Through the `gobject.ParamFlags` flag values, certain aspects of parameters
/// can be configured.
///
/// See also: `G_PARAM_STATIC_STRINGS`
pub const ParamFlags = packed struct(c_uint) {
    readable: bool = false,
    writable: bool = false,
    construct: bool = false,
    construct_only: bool = false,
    lax_validation: bool = false,
    static_name: bool = false,
    static_nick: bool = false,
    static_blurb: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    explicit_notify: bool = false,
    deprecated: bool = false,

    pub const flags_readable: ParamFlags = @bitCast(@as(c_uint, 1));
    pub const flags_writable: ParamFlags = @bitCast(@as(c_uint, 2));
    pub const flags_readwrite: ParamFlags = @bitCast(@as(c_uint, 3));
    pub const flags_construct: ParamFlags = @bitCast(@as(c_uint, 4));
    pub const flags_construct_only: ParamFlags = @bitCast(@as(c_uint, 8));
    pub const flags_lax_validation: ParamFlags = @bitCast(@as(c_uint, 16));
    pub const flags_static_name: ParamFlags = @bitCast(@as(c_uint, 32));
    pub const flags_private: ParamFlags = @bitCast(@as(c_uint, 32));
    pub const flags_static_nick: ParamFlags = @bitCast(@as(c_uint, 64));
    pub const flags_static_blurb: ParamFlags = @bitCast(@as(c_uint, 128));
    pub const flags_explicit_notify: ParamFlags = @bitCast(@as(c_uint, 1073741824));
    pub const flags_deprecated: ParamFlags = @bitCast(@as(c_uint, 2147483648));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The signal flags are used to specify a signal's behaviour.
pub const SignalFlags = packed struct(c_uint) {
    run_first: bool = false,
    run_last: bool = false,
    run_cleanup: bool = false,
    no_recurse: bool = false,
    detailed: bool = false,
    action: bool = false,
    no_hooks: bool = false,
    must_collect: bool = false,
    deprecated: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    accumulator_first_run: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_run_first: SignalFlags = @bitCast(@as(c_uint, 1));
    pub const flags_run_last: SignalFlags = @bitCast(@as(c_uint, 2));
    pub const flags_run_cleanup: SignalFlags = @bitCast(@as(c_uint, 4));
    pub const flags_no_recurse: SignalFlags = @bitCast(@as(c_uint, 8));
    pub const flags_detailed: SignalFlags = @bitCast(@as(c_uint, 16));
    pub const flags_action: SignalFlags = @bitCast(@as(c_uint, 32));
    pub const flags_no_hooks: SignalFlags = @bitCast(@as(c_uint, 64));
    pub const flags_must_collect: SignalFlags = @bitCast(@as(c_uint, 128));
    pub const flags_deprecated: SignalFlags = @bitCast(@as(c_uint, 256));
    pub const flags_accumulator_first_run: SignalFlags = @bitCast(@as(c_uint, 131072));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The match types specify what `gobject.signalHandlersBlockMatched`,
/// `gobject.signalHandlersUnblockMatched` and `gobject.signalHandlersDisconnectMatched`
/// match signals by.
pub const SignalMatchType = packed struct(c_uint) {
    id: bool = false,
    detail: bool = false,
    closure: bool = false,
    func: bool = false,
    data: bool = false,
    unblocked: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_id: SignalMatchType = @bitCast(@as(c_uint, 1));
    pub const flags_detail: SignalMatchType = @bitCast(@as(c_uint, 2));
    pub const flags_closure: SignalMatchType = @bitCast(@as(c_uint, 4));
    pub const flags_func: SignalMatchType = @bitCast(@as(c_uint, 8));
    pub const flags_data: SignalMatchType = @bitCast(@as(c_uint, 16));
    pub const flags_unblocked: SignalMatchType = @bitCast(@as(c_uint, 32));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// These flags used to be passed to `gobject.typeInitWithDebugFlags` which
/// is now deprecated.
///
/// If you need to enable debugging features, use the `GOBJECT_DEBUG`
/// environment variable.
pub const TypeDebugFlags = packed struct(c_uint) {
    objects: bool = false,
    signals: bool = false,
    instance_count: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: TypeDebugFlags = @bitCast(@as(c_uint, 0));
    pub const flags_objects: TypeDebugFlags = @bitCast(@as(c_uint, 1));
    pub const flags_signals: TypeDebugFlags = @bitCast(@as(c_uint, 2));
    pub const flags_instance_count: TypeDebugFlags = @bitCast(@as(c_uint, 4));
    pub const flags_mask: TypeDebugFlags = @bitCast(@as(c_uint, 7));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Bit masks used to check or determine characteristics of a type.
pub const TypeFlags = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    abstract: bool = false,
    value_abstract: bool = false,
    final: bool = false,
    deprecated: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: TypeFlags = @bitCast(@as(c_uint, 0));
    pub const flags_abstract: TypeFlags = @bitCast(@as(c_uint, 16));
    pub const flags_value_abstract: TypeFlags = @bitCast(@as(c_uint, 32));
    pub const flags_final: TypeFlags = @bitCast(@as(c_uint, 64));
    pub const flags_deprecated: TypeFlags = @bitCast(@as(c_uint, 128));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Bit masks used to check or determine specific characteristics of a
/// fundamental type.
pub const TypeFundamentalFlags = packed struct(c_uint) {
    classed: bool = false,
    instantiatable: bool = false,
    derivable: bool = false,
    deep_derivable: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_classed: TypeFundamentalFlags = @bitCast(@as(c_uint, 1));
    pub const flags_instantiatable: TypeFundamentalFlags = @bitCast(@as(c_uint, 2));
    pub const flags_derivable: TypeFundamentalFlags = @bitCast(@as(c_uint, 4));
    pub const flags_deep_derivable: TypeFundamentalFlags = @bitCast(@as(c_uint, 8));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Provide a copy of a boxed structure `src_boxed` which is of type `boxed_type`.
extern fn g_boxed_copy(p_boxed_type: usize, p_src_boxed: *const anyopaque) *anyopaque;
pub const boxedCopy = g_boxed_copy;

/// Free the boxed structure `boxed` which is of type `boxed_type`.
extern fn g_boxed_free(p_boxed_type: usize, p_boxed: *anyopaque) void;
pub const boxedFree = g_boxed_free;

/// This function creates a new `G_TYPE_BOXED` derived type id for a new
/// boxed type with name `name`.
///
/// Boxed type handling functions have to be provided to copy and free
/// opaque boxed structures of this type.
///
/// For the general case, it is recommended to use `G_DEFINE_BOXED_TYPE`
/// instead of calling `gobject.boxedTypeRegisterStatic` directly. The macro
/// will create the appropriate `*`_get_type`` function for the boxed type.
extern fn g_boxed_type_register_static(p_name: [*:0]const u8, p_boxed_copy: gobject.BoxedCopyFunc, p_boxed_free: gobject.BoxedFreeFunc) usize;
pub const boxedTypeRegisterStatic = g_boxed_type_register_static;

/// Clears a reference to a `gobject.Object`.
///
/// `object_ptr` must not be `NULL`.
///
/// If the reference is `NULL` then this function does nothing.
/// Otherwise, the reference count of the object is decreased and the
/// pointer is set to `NULL`.
///
/// A macro is also included that allows this function to be used without
/// pointer casts.
extern fn g_clear_object(p_object_ptr: **gobject.Object) void;
pub const clearObject = g_clear_object;

/// Disconnects a handler from `instance` so it will not be called during
/// any future or currently ongoing emissions of the signal it has been
/// connected to. The `handler_id_ptr` is then set to zero, which is never a valid handler ID value (see `g_signal_connect`).
///
/// If the handler ID is 0 then this function does nothing.
///
/// There is also a macro version of this function so that the code
/// will be inlined.
extern fn g_clear_signal_handler(p_handler_id_ptr: *c_ulong, p_instance: *gobject.Object) void;
pub const clearSignalHandler = g_clear_signal_handler;

/// This function is meant to be called from the `complete_type_info`
/// function of a `gobject.TypePlugin` implementation, as in the following
/// example:
///
/// ```
/// static void
/// my_enum_complete_type_info (GTypePlugin     *plugin,
///                             GType            g_type,
///                             GTypeInfo       *info,
///                             GTypeValueTable *value_table)
/// {
///   static const GEnumValue values[] = {
///     { MY_ENUM_FOO, "MY_ENUM_FOO", "foo" },
///     { MY_ENUM_BAR, "MY_ENUM_BAR", "bar" },
///     { 0, NULL, NULL }
///   };
///
///   g_enum_complete_type_info (type, info, values);
/// }
/// ```
extern fn g_enum_complete_type_info(p_g_enum_type: usize, p_info: *gobject.TypeInfo, p_const_values: *const gobject.EnumValue) void;
pub const enumCompleteTypeInfo = g_enum_complete_type_info;

/// Returns the `gobject.EnumValue` for a value.
extern fn g_enum_get_value(p_enum_class: *gobject.EnumClass, p_value: c_int) ?*gobject.EnumValue;
pub const enumGetValue = g_enum_get_value;

/// Looks up a `gobject.EnumValue` by name.
extern fn g_enum_get_value_by_name(p_enum_class: *gobject.EnumClass, p_name: [*:0]const u8) ?*gobject.EnumValue;
pub const enumGetValueByName = g_enum_get_value_by_name;

/// Looks up a `gobject.EnumValue` by nickname.
extern fn g_enum_get_value_by_nick(p_enum_class: *gobject.EnumClass, p_nick: [*:0]const u8) ?*gobject.EnumValue;
pub const enumGetValueByNick = g_enum_get_value_by_nick;

/// Registers a new static enumeration type with the name `name`.
///
/// It is normally more convenient to let [glib-mkenums][glib-mkenums],
/// generate a `my_enum_get_type` function from a usual C enumeration
/// definition  than to write one yourself using `gobject.enumRegisterStatic`.
extern fn g_enum_register_static(p_name: [*:0]const u8, p_const_static_values: [*]const gobject.EnumValue) usize;
pub const enumRegisterStatic = g_enum_register_static;

/// Pretty-prints `value` in the form of the enum’s name.
///
/// This is intended to be used for debugging purposes. The format of the output
/// may change in the future.
extern fn g_enum_to_string(p_g_enum_type: usize, p_value: c_int) [*:0]u8;
pub const enumToString = g_enum_to_string;

/// This function is meant to be called from the `complete_type_info`
/// function of a `gobject.TypePlugin` implementation, see the example for
/// `gobject.enumCompleteTypeInfo` above.
extern fn g_flags_complete_type_info(p_g_flags_type: usize, p_info: *gobject.TypeInfo, p_const_values: *const gobject.FlagsValue) void;
pub const flagsCompleteTypeInfo = g_flags_complete_type_info;

/// Returns the first `gobject.FlagsValue` which is set in `value`.
extern fn g_flags_get_first_value(p_flags_class: *gobject.FlagsClass, p_value: c_uint) ?*gobject.FlagsValue;
pub const flagsGetFirstValue = g_flags_get_first_value;

/// Looks up a `gobject.FlagsValue` by name.
extern fn g_flags_get_value_by_name(p_flags_class: *gobject.FlagsClass, p_name: [*:0]const u8) ?*gobject.FlagsValue;
pub const flagsGetValueByName = g_flags_get_value_by_name;

/// Looks up a `gobject.FlagsValue` by nickname.
extern fn g_flags_get_value_by_nick(p_flags_class: *gobject.FlagsClass, p_nick: [*:0]const u8) ?*gobject.FlagsValue;
pub const flagsGetValueByNick = g_flags_get_value_by_nick;

/// Registers a new static flags type with the name `name`.
///
/// It is normally more convenient to let [glib-mkenums][glib-mkenums]
/// generate a `my_flags_get_type` function from a usual C enumeration
/// definition than to write one yourself using `gobject.flagsRegisterStatic`.
extern fn g_flags_register_static(p_name: [*:0]const u8, p_const_static_values: [*]const gobject.FlagsValue) usize;
pub const flagsRegisterStatic = g_flags_register_static;

/// Pretty-prints `value` in the form of the flag names separated by ` | ` and
/// sorted. Any extra bits will be shown at the end as a hexadecimal number.
///
/// This is intended to be used for debugging purposes. The format of the output
/// may change in the future.
extern fn g_flags_to_string(p_flags_type: usize, p_value: c_uint) [*:0]u8;
pub const flagsToString = g_flags_to_string;

extern fn g_gtype_get_type() usize;
pub const gtypeGetType = g_gtype_get_type;

/// Creates a new `gobject.ParamSpecBoolean` instance specifying a `G_TYPE_BOOLEAN`
/// property. In many cases, it may be more appropriate to use an enum with
/// `gobject.paramSpecEnum`, both to improve code clarity by using explicitly named
/// values, and to allow for more values to be added in future without breaking
/// API.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_boolean(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_default_value: c_int, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecBoolean = g_param_spec_boolean;

/// Creates a new `gobject.ParamSpecBoxed` instance specifying a `G_TYPE_BOXED`
/// derived property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_boxed(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_boxed_type: usize, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecBoxed = g_param_spec_boxed;

/// Creates a new `gobject.ParamSpecChar` instance specifying a `G_TYPE_CHAR` property.
extern fn g_param_spec_char(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: i8, p_maximum: i8, p_default_value: i8, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecChar = g_param_spec_char;

/// Creates a new `gobject.ParamSpecDouble` instance specifying a `G_TYPE_DOUBLE`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_double(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: f64, p_maximum: f64, p_default_value: f64, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecDouble = g_param_spec_double;

/// Creates a new `gobject.ParamSpecEnum` instance specifying a `G_TYPE_ENUM`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_enum(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_enum_type: usize, p_default_value: c_int, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecEnum = g_param_spec_enum;

/// Creates a new `gobject.ParamSpecFlags` instance specifying a `G_TYPE_FLAGS`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_flags(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_flags_type: usize, p_default_value: c_uint, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecFlags = g_param_spec_flags;

/// Creates a new `gobject.ParamSpecFloat` instance specifying a `G_TYPE_FLOAT` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_float(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: f32, p_maximum: f32, p_default_value: f32, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecFloat = g_param_spec_float;

/// Creates a new `gobject.ParamSpecGType` instance specifying a
/// `G_TYPE_GTYPE` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_gtype(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_is_a_type: usize, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecGtype = g_param_spec_gtype;

/// Creates a new `gobject.ParamSpecInt` instance specifying a `G_TYPE_INT` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_int(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: c_int, p_maximum: c_int, p_default_value: c_int, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecInt = g_param_spec_int;

/// Creates a new `gobject.ParamSpecInt64` instance specifying a `G_TYPE_INT64` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_int64(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: i64, p_maximum: i64, p_default_value: i64, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecInt64 = g_param_spec_int64;

/// Creates a new `gobject.ParamSpecLong` instance specifying a `G_TYPE_LONG` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_long(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: c_long, p_maximum: c_long, p_default_value: c_long, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecLong = g_param_spec_long;

/// Creates a new `gobject.ParamSpecBoxed` instance specifying a `G_TYPE_OBJECT`
/// derived property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_object(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_object_type: usize, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecObject = g_param_spec_object;

/// Creates a new property of type `gobject.ParamSpecOverride`. This is used
/// to direct operations to another paramspec, and will not be directly
/// useful unless you are implementing a new base type similar to GObject.
extern fn g_param_spec_override(p_name: [*:0]const u8, p_overridden: *gobject.ParamSpec) *gobject.ParamSpec;
pub const paramSpecOverride = g_param_spec_override;

/// Creates a new `gobject.ParamSpecParam` instance specifying a `G_TYPE_PARAM`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_param(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_param_type: usize, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecParam = g_param_spec_param;

/// Creates a new `gobject.ParamSpecPointer` instance specifying a pointer property.
/// Where possible, it is better to use `gobject.paramSpecObject` or
/// `gobject.paramSpecBoxed` to expose memory management information.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_pointer(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecPointer = g_param_spec_pointer;

/// Creates a new `gobject.ParamSpecString` instance.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_string(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_default_value: ?[*:0]const u8, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecString = g_param_spec_string;

/// Creates a new `gobject.ParamSpecUChar` instance specifying a `G_TYPE_UCHAR` property.
extern fn g_param_spec_uchar(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: u8, p_maximum: u8, p_default_value: u8, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecUchar = g_param_spec_uchar;

/// Creates a new `gobject.ParamSpecUInt` instance specifying a `G_TYPE_UINT` property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_uint(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: c_uint, p_maximum: c_uint, p_default_value: c_uint, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecUint = g_param_spec_uint;

/// Creates a new `gobject.ParamSpecUInt64` instance specifying a `G_TYPE_UINT64`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_uint64(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: u64, p_maximum: u64, p_default_value: u64, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecUint64 = g_param_spec_uint64;

/// Creates a new `gobject.ParamSpecULong` instance specifying a `G_TYPE_ULONG`
/// property.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_ulong(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_minimum: c_ulong, p_maximum: c_ulong, p_default_value: c_ulong, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecUlong = g_param_spec_ulong;

/// Creates a new `gobject.ParamSpecUnichar` instance specifying a `G_TYPE_UINT`
/// property. `gobject.Value` structures for this property can be accessed with
/// `gobject.Value.setUint` and `gobject.Value.getUint`.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_unichar(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_default_value: u32, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecUnichar = g_param_spec_unichar;

/// Creates a new `gobject.ParamSpecValueArray` instance specifying a
/// `G_TYPE_VALUE_ARRAY` property. `G_TYPE_VALUE_ARRAY` is a
/// `G_TYPE_BOXED` type, as such, `gobject.Value` structures for this property
/// can be accessed with `gobject.Value.setBoxed` and `gobject.Value.getBoxed`.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_value_array(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_element_spec: *gobject.ParamSpec, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecValueArray = g_param_spec_value_array;

/// Creates a new `gobject.ParamSpecVariant` instance specifying a `glib.Variant`
/// property.
///
/// If `default_value` is floating, it is consumed.
///
/// See `gobject.ParamSpec.internal` for details on property names.
extern fn g_param_spec_variant(p_name: [*:0]const u8, p_nick: ?[*:0]const u8, p_blurb: ?[*:0]const u8, p_type: *const glib.VariantType, p_default_value: ?*glib.Variant, p_flags: gobject.ParamFlags) *gobject.ParamSpec;
pub const paramSpecVariant = g_param_spec_variant;

/// Registers `name` as the name of a new static type derived
/// from `G_TYPE_PARAM`.
///
/// The type system uses the information contained in the `gobject.ParamSpecTypeInfo`
/// structure pointed to by `info` to manage the `gobject.ParamSpec` type and its
/// instances.
extern fn g_param_type_register_static(p_name: [*:0]const u8, p_pspec_info: *const gobject.ParamSpecTypeInfo) usize;
pub const paramTypeRegisterStatic = g_param_type_register_static;

/// Transforms `src_value` into `dest_value` if possible, and then
/// validates `dest_value`, in order for it to conform to `pspec`.  If
/// `strict_validation` is `TRUE` this function will only succeed if the
/// transformed `dest_value` complied to `pspec` without modifications.
///
/// See also `gobject.valueTypeTransformable`, `gobject.Value.transform` and
/// `gobject.paramValueValidate`.
extern fn g_param_value_convert(p_pspec: *gobject.ParamSpec, p_src_value: *const gobject.Value, p_dest_value: *gobject.Value, p_strict_validation: c_int) c_int;
pub const paramValueConvert = g_param_value_convert;

/// Checks whether `value` contains the default value as specified in `pspec`.
extern fn g_param_value_defaults(p_pspec: *gobject.ParamSpec, p_value: *const gobject.Value) c_int;
pub const paramValueDefaults = g_param_value_defaults;

/// Return whether the contents of `value` comply with the specifications
/// set out by `pspec`.
extern fn g_param_value_is_valid(p_pspec: *gobject.ParamSpec, p_value: *const gobject.Value) c_int;
pub const paramValueIsValid = g_param_value_is_valid;

/// Sets `value` to its default value as specified in `pspec`.
extern fn g_param_value_set_default(p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) void;
pub const paramValueSetDefault = g_param_value_set_default;

/// Ensures that the contents of `value` comply with the specifications
/// set out by `pspec`. For example, a `gobject.ParamSpecInt` might require
/// that integers stored in `value` may not be smaller than -42 and not be
/// greater than +42. If `value` contains an integer outside of this range,
/// it is modified accordingly, so the resulting value will fit into the
/// range -42 .. +42.
extern fn g_param_value_validate(p_pspec: *gobject.ParamSpec, p_value: *gobject.Value) c_int;
pub const paramValueValidate = g_param_value_validate;

/// Compares `value1` with `value2` according to `pspec`, and return -1, 0 or +1,
/// if `value1` is found to be less than, equal to or greater than `value2`,
/// respectively.
extern fn g_param_values_cmp(p_pspec: *gobject.ParamSpec, p_value1: *const gobject.Value, p_value2: *const gobject.Value) c_int;
pub const paramValuesCmp = g_param_values_cmp;

/// Creates a new `G_TYPE_POINTER` derived type id for a new
/// pointer type with name `name`.
extern fn g_pointer_type_register_static(p_name: [*:0]const u8) usize;
pub const pointerTypeRegisterStatic = g_pointer_type_register_static;

/// A predefined `gobject.SignalAccumulator` for signals intended to be used as a
/// hook for application code to provide a particular value.  Usually
/// only one such value is desired and multiple handlers for the same
/// signal don't make much sense (except for the case of the default
/// handler defined in the class structure, in which case you will
/// usually want the signal connection to override the class handler).
///
/// This accumulator will use the return value from the first signal
/// handler that is run as the return value for the signal and not run
/// any further handlers (ie: the first handler "wins").
extern fn g_signal_accumulator_first_wins(p_ihint: *gobject.SignalInvocationHint, p_return_accu: *gobject.Value, p_handler_return: *const gobject.Value, p_dummy: ?*anyopaque) c_int;
pub const signalAccumulatorFirstWins = g_signal_accumulator_first_wins;

/// A predefined `gobject.SignalAccumulator` for signals that return a
/// boolean values. The behavior that this accumulator gives is
/// that a return of `TRUE` stops the signal emission: no further
/// callbacks will be invoked, while a return of `FALSE` allows
/// the emission to continue. The idea here is that a `TRUE` return
/// indicates that the callback handled the signal, and no further
/// handling is needed.
extern fn g_signal_accumulator_true_handled(p_ihint: *gobject.SignalInvocationHint, p_return_accu: *gobject.Value, p_handler_return: *const gobject.Value, p_dummy: ?*anyopaque) c_int;
pub const signalAccumulatorTrueHandled = g_signal_accumulator_true_handled;

/// Adds an emission hook for a signal, which will get called for any emission
/// of that signal, independent of the instance. This is possible only
/// for signals which don't have `G_SIGNAL_NO_HOOKS` flag set.
extern fn g_signal_add_emission_hook(p_signal_id: c_uint, p_detail: glib.Quark, p_hook_func: gobject.SignalEmissionHook, p_hook_data: ?*anyopaque, p_data_destroy: ?glib.DestroyNotify) c_ulong;
pub const signalAddEmissionHook = g_signal_add_emission_hook;

/// Calls the original class closure of a signal. This function should only
/// be called from an overridden class closure; see
/// `gobject.signalOverrideClassClosure` and
/// `gobject.signalOverrideClassHandler`.
extern fn g_signal_chain_from_overridden(p_instance_and_params: [*]const gobject.Value, p_return_value: *gobject.Value) void;
pub const signalChainFromOverridden = g_signal_chain_from_overridden;

/// Calls the original class closure of a signal. This function should
/// only be called from an overridden class closure; see
/// `gobject.signalOverrideClassClosure` and
/// `gobject.signalOverrideClassHandler`.
extern fn g_signal_chain_from_overridden_handler(p_instance: *gobject.TypeInstance, ...) void;
pub const signalChainFromOverriddenHandler = g_signal_chain_from_overridden_handler;

/// Connects a closure to a signal for a particular object.
///
/// If `closure` is a floating reference (see `gobject.Closure.sink`), this function
/// takes ownership of `closure`.
///
/// This function cannot fail. If the given signal name doesn’t exist,
/// a critical warning is emitted. No validation is performed on the
/// ‘detail’ string when specified in `detailed_signal`, other than a
/// non-empty check.
///
/// Refer to the [signals documentation](signals.html) for more
/// details.
extern fn g_signal_connect_closure(p_instance: *gobject.Object, p_detailed_signal: [*:0]const u8, p_closure: *gobject.Closure, p_after: c_int) c_ulong;
pub const signalConnectClosure = g_signal_connect_closure;

/// Connects a closure to a signal for a particular object.
///
/// If `closure` is a floating reference (see `gobject.Closure.sink`), this function
/// takes ownership of `closure`.
///
/// This function cannot fail. If the given signal name doesn’t exist,
/// a critical warning is emitted. No validation is performed on the
/// ‘detail’ string when specified in `detailed_signal`, other than a
/// non-empty check.
///
/// Refer to the [signals documentation](signals.html) for more
/// details.
extern fn g_signal_connect_closure_by_id(p_instance: *gobject.Object, p_signal_id: c_uint, p_detail: glib.Quark, p_closure: *gobject.Closure, p_after: c_int) c_ulong;
pub const signalConnectClosureById = g_signal_connect_closure_by_id;

/// Connects a `gobject.Callback` function to a signal for a particular object. Similar
/// to `g_signal_connect`, but allows to provide a `gobject.ClosureNotify` for the data
/// which will be called when the signal handler is disconnected and no longer
/// used. Specify `connect_flags` if you need `...`_after`` or
/// `...`_swapped`` variants of this function.
///
/// This function cannot fail. If the given signal name doesn’t exist,
/// a critical warning is emitted. No validation is performed on the
/// ‘detail’ string when specified in `detailed_signal`, other than a
/// non-empty check.
///
/// Refer to the [signals documentation](signals.html) for more
/// details.
extern fn g_signal_connect_data(p_instance: *gobject.Object, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_data: ?*anyopaque, p_destroy_data: ?gobject.ClosureNotify, p_connect_flags: gobject.ConnectFlags) c_ulong;
pub const signalConnectData = g_signal_connect_data;

/// This is similar to `gobject.signalConnectData`, but uses a closure which
/// ensures that the `gobject` stays alive during the call to `c_handler`
/// by temporarily adding a reference count to `gobject`.
///
/// When the `gobject` is destroyed the signal handler will be automatically
/// disconnected.  Note that this is not currently threadsafe (ie:
/// emitting a signal while `gobject` is being destroyed in another thread
/// is not safe).
///
/// This function cannot fail. If the given signal name doesn’t exist,
/// a critical warning is emitted. No validation is performed on the
/// "detail" string when specified in `detailed_signal`, other than a
/// non-empty check.
///
/// Refer to the [signals documentation](signals.html) for more
/// details.
extern fn g_signal_connect_object(p_instance: *gobject.TypeInstance, p_detailed_signal: [*:0]const u8, p_c_handler: gobject.Callback, p_gobject: ?*gobject.Object, p_connect_flags: gobject.ConnectFlags) c_ulong;
pub const signalConnectObject = g_signal_connect_object;

/// Emits a signal. Signal emission is done synchronously.
/// The method will only return control after all handlers are called or signal emission was stopped.
///
/// Note that `gobject.signalEmit` resets the return value to the default
/// if no handlers are connected, in contrast to `gobject.signalEmitv`.
extern fn g_signal_emit(p_instance: *gobject.Object, p_signal_id: c_uint, p_detail: glib.Quark, ...) void;
pub const signalEmit = g_signal_emit;

/// Emits a signal. Signal emission is done synchronously.
/// The method will only return control after all handlers are called or signal emission was stopped.
///
/// Note that `gobject.signalEmitByName` resets the return value to the default
/// if no handlers are connected, in contrast to `gobject.signalEmitv`.
extern fn g_signal_emit_by_name(p_instance: *gobject.Object, p_detailed_signal: [*:0]const u8, ...) void;
pub const signalEmitByName = g_signal_emit_by_name;

/// Emits a signal. Signal emission is done synchronously.
/// The method will only return control after all handlers are called or signal emission was stopped.
///
/// Note that `gobject.signalEmitValist` resets the return value to the default
/// if no handlers are connected, in contrast to `gobject.signalEmitv`.
extern fn g_signal_emit_valist(p_instance: *gobject.TypeInstance, p_signal_id: c_uint, p_detail: glib.Quark, p_var_args: std.builtin.VaList) void;
pub const signalEmitValist = g_signal_emit_valist;

/// Emits a signal. Signal emission is done synchronously.
/// The method will only return control after all handlers are called or signal emission was stopped.
///
/// Note that `gobject.signalEmitv` doesn't change `return_value` if no handlers are
/// connected, in contrast to `gobject.signalEmit` and `gobject.signalEmitValist`.
extern fn g_signal_emitv(p_instance_and_params: [*]const gobject.Value, p_signal_id: c_uint, p_detail: glib.Quark, p_return_value: ?*gobject.Value) void;
pub const signalEmitv = g_signal_emitv;

/// Returns the invocation hint of the innermost signal emission of instance.
extern fn g_signal_get_invocation_hint(p_instance: *gobject.Object) ?*gobject.SignalInvocationHint;
pub const signalGetInvocationHint = g_signal_get_invocation_hint;

/// Blocks a handler of an instance so it will not be called during any
/// signal emissions unless it is unblocked again. Thus "blocking" a
/// signal handler means to temporarily deactivate it, a signal handler
/// has to be unblocked exactly the same amount of times it has been
/// blocked before to become active again.
///
/// The `handler_id` has to be a valid signal handler id, connected to a
/// signal of `instance`.
extern fn g_signal_handler_block(p_instance: *gobject.Object, p_handler_id: c_ulong) void;
pub const signalHandlerBlock = g_signal_handler_block;

/// Disconnects a handler from an instance so it will not be called during
/// any future or currently ongoing emissions of the signal it has been
/// connected to. The `handler_id` becomes invalid and may be reused.
///
/// The `handler_id` has to be a valid signal handler id, connected to a
/// signal of `instance`.
extern fn g_signal_handler_disconnect(p_instance: *gobject.Object, p_handler_id: c_ulong) void;
pub const signalHandlerDisconnect = g_signal_handler_disconnect;

/// Finds the first signal handler that matches certain selection criteria.
/// The criteria mask is passed as an OR-ed combination of `gobject.SignalMatchType`
/// flags, and the criteria values are passed as arguments.
/// The match `mask` has to be non-0 for successful matches.
/// If no handler was found, 0 is returned.
extern fn g_signal_handler_find(p_instance: *gobject.Object, p_mask: gobject.SignalMatchType, p_signal_id: c_uint, p_detail: glib.Quark, p_closure: ?*gobject.Closure, p_func: ?*anyopaque, p_data: ?*anyopaque) c_ulong;
pub const signalHandlerFind = g_signal_handler_find;

/// Returns whether `handler_id` is the ID of a handler connected to `instance`.
extern fn g_signal_handler_is_connected(p_instance: *gobject.Object, p_handler_id: c_ulong) c_int;
pub const signalHandlerIsConnected = g_signal_handler_is_connected;

/// Undoes the effect of a previous `gobject.signalHandlerBlock` call.  A
/// blocked handler is skipped during signal emissions and will not be
/// invoked, unblocking it (for exactly the amount of times it has been
/// blocked before) reverts its "blocked" state, so the handler will be
/// recognized by the signal system and is called upon future or
/// currently ongoing signal emissions (since the order in which
/// handlers are called during signal emissions is deterministic,
/// whether the unblocked handler in question is called as part of a
/// currently ongoing emission depends on how far that emission has
/// proceeded yet).
///
/// The `handler_id` has to be a valid id of a signal handler that is
/// connected to a signal of `instance` and is currently blocked.
extern fn g_signal_handler_unblock(p_instance: *gobject.Object, p_handler_id: c_ulong) void;
pub const signalHandlerUnblock = g_signal_handler_unblock;

/// Blocks all handlers on an instance that match a certain selection criteria.
///
/// The criteria mask is passed as a combination of `gobject.SignalMatchType` flags, and
/// the criteria values are passed as arguments. A handler must match on all
/// flags set in `mask` to be blocked (i.e. the match is conjunctive).
///
/// Passing at least one of the `G_SIGNAL_MATCH_ID`, `G_SIGNAL_MATCH_CLOSURE`,
/// `G_SIGNAL_MATCH_FUNC`
/// or `G_SIGNAL_MATCH_DATA` match flags is required for successful matches.
/// If no handlers were found, 0 is returned, the number of blocked handlers
/// otherwise.
///
/// Support for `G_SIGNAL_MATCH_ID` was added in GLib 2.78.
extern fn g_signal_handlers_block_matched(p_instance: *gobject.Object, p_mask: gobject.SignalMatchType, p_signal_id: c_uint, p_detail: glib.Quark, p_closure: ?*gobject.Closure, p_func: ?*anyopaque, p_data: ?*anyopaque) c_uint;
pub const signalHandlersBlockMatched = g_signal_handlers_block_matched;

/// Destroy all signal handlers of a type instance. This function is
/// an implementation detail of the `gobject.Object` dispose implementation,
/// and should not be used outside of the type system.
extern fn g_signal_handlers_destroy(p_instance: *gobject.Object) void;
pub const signalHandlersDestroy = g_signal_handlers_destroy;

/// Disconnects all handlers on an instance that match a certain
/// selection criteria.
///
/// The criteria mask is passed as a combination of `gobject.SignalMatchType` flags, and
/// the criteria values are passed as arguments. A handler must match on all
/// flags set in `mask` to be disconnected (i.e. the match is conjunctive).
///
/// Passing at least one of the `G_SIGNAL_MATCH_ID`, `G_SIGNAL_MATCH_CLOSURE`,
/// `G_SIGNAL_MATCH_FUNC` or
/// `G_SIGNAL_MATCH_DATA` match flags is required for successful
/// matches.  If no handlers were found, 0 is returned, the number of
/// disconnected handlers otherwise.
///
/// Support for `G_SIGNAL_MATCH_ID` was added in GLib 2.78.
extern fn g_signal_handlers_disconnect_matched(p_instance: *gobject.Object, p_mask: gobject.SignalMatchType, p_signal_id: c_uint, p_detail: glib.Quark, p_closure: ?*gobject.Closure, p_func: ?*anyopaque, p_data: ?*anyopaque) c_uint;
pub const signalHandlersDisconnectMatched = g_signal_handlers_disconnect_matched;

/// Unblocks all handlers on an instance that match a certain selection
/// criteria.
///
/// The criteria mask is passed as a combination of `gobject.SignalMatchType` flags, and
/// the criteria values are passed as arguments. A handler must match on all
/// flags set in `mask` to be unblocked (i.e. the match is conjunctive).
///
/// Passing at least one of the `G_SIGNAL_MATCH_ID`, `G_SIGNAL_MATCH_CLOSURE`,
/// `G_SIGNAL_MATCH_FUNC`
/// or `G_SIGNAL_MATCH_DATA` match flags is required for successful matches.
/// If no handlers were found, 0 is returned, the number of unblocked handlers
/// otherwise. The match criteria should not apply to any handlers that are
/// not currently blocked.
///
/// Support for `G_SIGNAL_MATCH_ID` was added in GLib 2.78.
extern fn g_signal_handlers_unblock_matched(p_instance: *gobject.Object, p_mask: gobject.SignalMatchType, p_signal_id: c_uint, p_detail: glib.Quark, p_closure: ?*gobject.Closure, p_func: ?*anyopaque, p_data: ?*anyopaque) c_uint;
pub const signalHandlersUnblockMatched = g_signal_handlers_unblock_matched;

/// Returns whether there are any handlers connected to `instance` for the
/// given signal id and detail.
///
/// If `detail` is 0 then it will only match handlers that were connected
/// without detail.  If `detail` is non-zero then it will match handlers
/// connected both without detail and with the given detail.  This is
/// consistent with how a signal emitted with `detail` would be delivered
/// to those handlers.
///
/// Since 2.46 this also checks for a non-default class closure being
/// installed, as this is basically always what you want.
///
/// One example of when you might use this is when the arguments to the
/// signal are difficult to compute. A class implementor may opt to not
/// emit the signal if no one is attached anyway, thus saving the cost
/// of building the arguments.
extern fn g_signal_has_handler_pending(p_instance: *gobject.Object, p_signal_id: c_uint, p_detail: glib.Quark, p_may_be_blocked: c_int) c_int;
pub const signalHasHandlerPending = g_signal_has_handler_pending;

/// Validate a signal name. This can be useful for dynamically-generated signals
/// which need to be validated at run-time before actually trying to create them.
///
/// See `gobject.signalNew` for details of the rules for valid names.
/// The rules for signal names are the same as those for property names.
extern fn g_signal_is_valid_name(p_name: [*:0]const u8) c_int;
pub const signalIsValidName = g_signal_is_valid_name;

/// Lists the signals by id that a certain instance or interface type
/// created. Further information about the signals can be acquired through
/// `gobject.signalQuery`.
extern fn g_signal_list_ids(p_itype: usize, p_n_ids: *c_uint) [*]c_uint;
pub const signalListIds = g_signal_list_ids;

/// Given the name of the signal and the type of object it connects to, gets
/// the signal's identifying integer. Emitting the signal by number is
/// somewhat faster than using the name each time.
///
/// Also tries the ancestors of the given type.
///
/// The type class passed as `itype` must already have been instantiated (for
/// example, using `gobject.typeClassRef`) for this function to work, as signals are
/// always installed during class initialization.
///
/// See `gobject.signalNew` for details on allowed signal names.
extern fn g_signal_lookup(p_name: [*:0]const u8, p_itype: usize) c_uint;
pub const signalLookup = g_signal_lookup;

/// Given the signal's identifier, finds its name.
///
/// Two different signals may have the same name, if they have differing types.
extern fn g_signal_name(p_signal_id: c_uint) ?[*:0]const u8;
pub const signalName = g_signal_name;

/// Creates a new signal. (This is usually done in the class initializer.)
///
/// A signal name consists of segments consisting of ASCII letters and
/// digits, separated by either the `-` or `_` character. The first
/// character of a signal name must be a letter. Names which violate these
/// rules lead to undefined behaviour. These are the same rules as for property
/// naming (see `gobject.ParamSpec.internal`).
///
/// When registering a signal and looking up a signal, either separator can
/// be used, but they cannot be mixed. Using `-` is considerably more efficient.
/// Using `_` is discouraged.
///
/// If 0 is used for `class_offset` subclasses cannot override the class handler
/// in their class_init method by doing super_class->signal_handler = my_signal_handler.
/// Instead they will have to use `gobject.signalOverrideClassHandler`.
///
/// If `c_marshaller` is `NULL`, `gobject.cclosureMarshalGeneric` will be used as
/// the marshaller for this signal. In some simple cases, `gobject.signalNew`
/// will use a more optimized c_marshaller and va_marshaller for the signal
/// instead of `gobject.cclosureMarshalGeneric`.
///
/// If `c_marshaller` is non-`NULL`, you need to also specify a va_marshaller
/// using `gobject.signalSetVaMarshaller` or the generic va_marshaller will
/// be used.
extern fn g_signal_new(p_signal_name: [*:0]const u8, p_itype: usize, p_signal_flags: gobject.SignalFlags, p_class_offset: c_uint, p_accumulator: ?gobject.SignalAccumulator, p_accu_data: ?*anyopaque, p_c_marshaller: ?gobject.SignalCMarshaller, p_return_type: usize, p_n_params: c_uint, ...) c_uint;
pub const signalNew = g_signal_new;

/// Creates a new signal. (This is usually done in the class initializer.)
///
/// This is a variant of `gobject.signalNew` that takes a C callback instead
/// of a class offset for the signal's class handler. This function
/// doesn't need a function pointer exposed in the class structure of
/// an object definition, instead the function pointer is passed
/// directly and can be overridden by derived classes with
/// `gobject.signalOverrideClassClosure` or
/// `gobject.signalOverrideClassHandler` and chained to with
/// `gobject.signalChainFromOverridden` or
/// `gobject.signalChainFromOverriddenHandler`.
///
/// See `gobject.signalNew` for information about signal names.
///
/// If c_marshaller is `NULL`, `gobject.cclosureMarshalGeneric` will be used as
/// the marshaller for this signal.
extern fn g_signal_new_class_handler(p_signal_name: [*:0]const u8, p_itype: usize, p_signal_flags: gobject.SignalFlags, p_class_handler: ?gobject.Callback, p_accumulator: ?gobject.SignalAccumulator, p_accu_data: ?*anyopaque, p_c_marshaller: ?gobject.SignalCMarshaller, p_return_type: usize, p_n_params: c_uint, ...) c_uint;
pub const signalNewClassHandler = g_signal_new_class_handler;

/// Creates a new signal. (This is usually done in the class initializer.)
///
/// See `gobject.signalNew` for details on allowed signal names.
///
/// If c_marshaller is `NULL`, `gobject.cclosureMarshalGeneric` will be used as
/// the marshaller for this signal.
extern fn g_signal_new_valist(p_signal_name: [*:0]const u8, p_itype: usize, p_signal_flags: gobject.SignalFlags, p_class_closure: ?*gobject.Closure, p_accumulator: ?gobject.SignalAccumulator, p_accu_data: ?*anyopaque, p_c_marshaller: ?gobject.SignalCMarshaller, p_return_type: usize, p_n_params: c_uint, p_args: std.builtin.VaList) c_uint;
pub const signalNewValist = g_signal_new_valist;

/// Creates a new signal. (This is usually done in the class initializer.)
///
/// See `gobject.signalNew` for details on allowed signal names.
///
/// If c_marshaller is `NULL`, `gobject.cclosureMarshalGeneric` will be used as
/// the marshaller for this signal.
extern fn g_signal_newv(p_signal_name: [*:0]const u8, p_itype: usize, p_signal_flags: gobject.SignalFlags, p_class_closure: ?*gobject.Closure, p_accumulator: ?gobject.SignalAccumulator, p_accu_data: ?*anyopaque, p_c_marshaller: ?gobject.SignalCMarshaller, p_return_type: usize, p_n_params: c_uint, p_param_types: ?[*]usize) c_uint;
pub const signalNewv = g_signal_newv;

/// Overrides the class closure (i.e. the default handler) for the given signal
/// for emissions on instances of `instance_type`. `instance_type` must be derived
/// from the type to which the signal belongs.
///
/// See `gobject.signalChainFromOverridden` and
/// `gobject.signalChainFromOverriddenHandler` for how to chain up to the
/// parent class closure from inside the overridden one.
extern fn g_signal_override_class_closure(p_signal_id: c_uint, p_instance_type: usize, p_class_closure: *gobject.Closure) void;
pub const signalOverrideClassClosure = g_signal_override_class_closure;

/// Overrides the class closure (i.e. the default handler) for the
/// given signal for emissions on instances of `instance_type` with
/// callback `class_handler`. `instance_type` must be derived from the
/// type to which the signal belongs.
///
/// See `gobject.signalChainFromOverridden` and
/// `gobject.signalChainFromOverriddenHandler` for how to chain up to the
/// parent class closure from inside the overridden one.
extern fn g_signal_override_class_handler(p_signal_name: [*:0]const u8, p_instance_type: usize, p_class_handler: gobject.Callback) void;
pub const signalOverrideClassHandler = g_signal_override_class_handler;

/// Internal function to parse a signal name into its `signal_id`
/// and `detail` quark.
extern fn g_signal_parse_name(p_detailed_signal: [*:0]const u8, p_itype: usize, p_signal_id_p: *c_uint, p_detail_p: *glib.Quark, p_force_detail_quark: c_int) c_int;
pub const signalParseName = g_signal_parse_name;

/// Queries the signal system for in-depth information about a
/// specific signal. This function will fill in a user-provided
/// structure to hold signal-specific information. If an invalid
/// signal id is passed in, the `signal_id` member of the `gobject.SignalQuery`
/// is 0. All members filled into the `gobject.SignalQuery` structure should
/// be considered constant and have to be left untouched.
extern fn g_signal_query(p_signal_id: c_uint, p_query: *gobject.SignalQuery) void;
pub const signalQuery = g_signal_query;

/// Deletes an emission hook.
extern fn g_signal_remove_emission_hook(p_signal_id: c_uint, p_hook_id: c_ulong) void;
pub const signalRemoveEmissionHook = g_signal_remove_emission_hook;

/// Change the `gobject.SignalCVaMarshaller` used for a given signal.  This is a
/// specialised form of the marshaller that can often be used for the
/// common case of a single connected signal handler and avoids the
/// overhead of `gobject.Value`.  Its use is optional.
extern fn g_signal_set_va_marshaller(p_signal_id: c_uint, p_instance_type: usize, p_va_marshaller: gobject.SignalCVaMarshaller) void;
pub const signalSetVaMarshaller = g_signal_set_va_marshaller;

/// Stops a signal's current emission.
///
/// This will prevent the default method from running, if the signal was
/// `G_SIGNAL_RUN_LAST` and you connected normally (i.e. without the "after"
/// flag).
///
/// Prints a warning if used on a signal which isn't being emitted.
extern fn g_signal_stop_emission(p_instance: *gobject.Object, p_signal_id: c_uint, p_detail: glib.Quark) void;
pub const signalStopEmission = g_signal_stop_emission;

/// Stops a signal's current emission.
///
/// This is just like `gobject.signalStopEmission` except it will look up the
/// signal id for you.
extern fn g_signal_stop_emission_by_name(p_instance: *gobject.Object, p_detailed_signal: [*:0]const u8) void;
pub const signalStopEmissionByName = g_signal_stop_emission_by_name;

/// Creates a new closure which invokes the function found at the offset
/// `struct_offset` in the class structure of the interface or classed type
/// identified by `itype`.
extern fn g_signal_type_cclosure_new(p_itype: usize, p_struct_offset: c_uint) *gobject.Closure;
pub const signalTypeCclosureNew = g_signal_type_cclosure_new;

/// Return a newly allocated string, which describes the contents of a
/// `gobject.Value`.  The main purpose of this function is to describe `gobject.Value`
/// contents for debugging output, the way in which the contents are
/// described may change between different GLib versions.
extern fn g_strdup_value_contents(p_value: *const gobject.Value) [*:0]u8;
pub const strdupValueContents = g_strdup_value_contents;

/// Adds a `gobject.TypeClassCacheFunc` to be called before the reference count of a
/// class goes from one to zero. This can be used to prevent premature class
/// destruction. All installed `gobject.TypeClassCacheFunc` functions will be chained
/// until one of them returns `TRUE`. The functions have to check the class id
/// passed in to figure whether they actually want to cache the class of this
/// type, since all classes are routed through the same `gobject.TypeClassCacheFunc`
/// chain.
extern fn g_type_add_class_cache_func(p_cache_data: ?*anyopaque, p_cache_func: gobject.TypeClassCacheFunc) void;
pub const typeAddClassCacheFunc = g_type_add_class_cache_func;

/// Registers a private class structure for a classed type;
/// when the class is allocated, the private structures for
/// the class and all of its parent types are allocated
/// sequentially in the same memory block as the public
/// structures, and are zero-filled.
///
/// This function should be called in the
/// type's `get_type` function after the type is registered.
/// The private structure can be retrieved using the
/// `G_TYPE_CLASS_GET_PRIVATE` macro.
extern fn g_type_add_class_private(p_class_type: usize, p_private_size: usize) void;
pub const typeAddClassPrivate = g_type_add_class_private;

extern fn g_type_add_instance_private(p_class_type: usize, p_private_size: usize) c_int;
pub const typeAddInstancePrivate = g_type_add_instance_private;

/// Adds a function to be called after an interface vtable is
/// initialized for any class (i.e. after the `interface_init`
/// member of `gobject.InterfaceInfo` has been called).
///
/// This function is useful when you want to check an invariant
/// that depends on the interfaces of a class. For instance, the
/// implementation of `gobject.Object` uses this facility to check that an
/// object implements all of the properties that are defined on its
/// interfaces.
extern fn g_type_add_interface_check(p_check_data: ?*anyopaque, p_check_func: gobject.TypeInterfaceCheckFunc) void;
pub const typeAddInterfaceCheck = g_type_add_interface_check;

/// Adds `interface_type` to the dynamic `instance_type`. The information
/// contained in the `gobject.TypePlugin` structure pointed to by `plugin`
/// is used to manage the relationship.
extern fn g_type_add_interface_dynamic(p_instance_type: usize, p_interface_type: usize, p_plugin: *gobject.TypePlugin) void;
pub const typeAddInterfaceDynamic = g_type_add_interface_dynamic;

/// Adds `interface_type` to the static `instance_type`.
/// The information contained in the `gobject.InterfaceInfo` structure
/// pointed to by `info` is used to manage the relationship.
extern fn g_type_add_interface_static(p_instance_type: usize, p_interface_type: usize, p_info: *const gobject.InterfaceInfo) void;
pub const typeAddInterfaceStatic = g_type_add_interface_static;

extern fn g_type_check_class_cast(p_g_class: *gobject.TypeClass, p_is_a_type: usize) *gobject.TypeClass;
pub const typeCheckClassCast = g_type_check_class_cast;

extern fn g_type_check_class_is_a(p_g_class: *gobject.TypeClass, p_is_a_type: usize) c_int;
pub const typeCheckClassIsA = g_type_check_class_is_a;

/// Private helper function to aid implementation of the
/// `G_TYPE_CHECK_INSTANCE` macro.
extern fn g_type_check_instance(p_instance: *gobject.TypeInstance) c_int;
pub const typeCheckInstance = g_type_check_instance;

extern fn g_type_check_instance_cast(p_instance: *gobject.TypeInstance, p_iface_type: usize) *gobject.TypeInstance;
pub const typeCheckInstanceCast = g_type_check_instance_cast;

extern fn g_type_check_instance_is_a(p_instance: *gobject.TypeInstance, p_iface_type: usize) c_int;
pub const typeCheckInstanceIsA = g_type_check_instance_is_a;

extern fn g_type_check_instance_is_fundamentally_a(p_instance: *gobject.TypeInstance, p_fundamental_type: usize) c_int;
pub const typeCheckInstanceIsFundamentallyA = g_type_check_instance_is_fundamentally_a;

extern fn g_type_check_is_value_type(p_type: usize) c_int;
pub const typeCheckIsValueType = g_type_check_is_value_type;

extern fn g_type_check_value(p_value: *const gobject.Value) c_int;
pub const typeCheckValue = g_type_check_value;

extern fn g_type_check_value_holds(p_value: *const gobject.Value, p_type: usize) c_int;
pub const typeCheckValueHolds = g_type_check_value_holds;

/// Return a newly allocated and 0-terminated array of type IDs, listing
/// the child types of `type`.
extern fn g_type_children(p_type: usize, p_n_children: ?*c_uint) [*]usize;
pub const typeChildren = g_type_children;

/// Creates and initializes an instance of `type` if `type` is valid and
/// can be instantiated. The type system only performs basic allocation
/// and structure setups for instances: actual instance creation should
/// happen through functions supplied by the type's fundamental type
/// implementation.  So use of `gobject.typeCreateInstance` is reserved for
/// implementers of fundamental types only. E.g. instances of the
/// `gobject.Object` hierarchy should be created via `gobject.Object.new` and never
/// directly through `gobject.typeCreateInstance` which doesn't handle things
/// like singleton objects or object construction.
///
/// The extended members of the returned instance are guaranteed to be filled
/// with zeros.
///
/// Note: Do not use this function, unless you're implementing a
/// fundamental type. Also language bindings should not use this
/// function, but `gobject.Object.new` instead.
extern fn g_type_create_instance(p_type: usize) *gobject.TypeInstance;
pub const typeCreateInstance = g_type_create_instance;

/// Returns the default interface vtable for the given `g_type`.
///
/// If the type is not currently in use, then the default vtable
/// for the type will be created and initialized by calling
/// the base interface init and default vtable init functions for
/// the type (the `base_init` and `class_init` members of `gobject.TypeInfo`).
///
/// If you don't want to create the interface vtable, you should use
/// `gobject.typeDefaultInterfacePeek` instead.
///
/// Calling `gobject.typeDefaultInterfaceGet` is useful when you
/// want to make sure that signals and properties for an interface
/// have been installed.
extern fn g_type_default_interface_get(p_g_type: usize) *gobject.TypeInterface;
pub const typeDefaultInterfaceGet = g_type_default_interface_get;

/// If the interface type `g_type` is currently in use, returns its
/// default interface vtable.
extern fn g_type_default_interface_peek(p_g_type: usize) *gobject.TypeInterface;
pub const typeDefaultInterfacePeek = g_type_default_interface_peek;

/// Increments the reference count for the interface type `g_type`,
/// and returns the default interface vtable for the type.
///
/// If the type is not currently in use, then the default vtable
/// for the type will be created and initialized by calling
/// the base interface init and default vtable init functions for
/// the type (the `base_init` and `class_init` members of `gobject.TypeInfo`).
/// Calling `gobject.typeDefaultInterfaceRef` is useful when you
/// want to make sure that signals and properties for an interface
/// have been installed.
extern fn g_type_default_interface_ref(p_g_type: usize) *gobject.TypeInterface;
pub const typeDefaultInterfaceRef = g_type_default_interface_ref;

/// Decrements the reference count for the type corresponding to the
/// interface default vtable `g_iface`.
///
/// If the type is dynamic, then when no one is using the interface and all
/// references have been released, the finalize function for the interface's
/// default vtable (the `class_finalize` member of `gobject.TypeInfo`) will be called.
extern fn g_type_default_interface_unref(p_g_iface: *gobject.TypeInterface) void;
pub const typeDefaultInterfaceUnref = g_type_default_interface_unref;

/// Returns the length of the ancestry of the passed in type. This
/// includes the type itself, so that e.g. a fundamental type has depth 1.
extern fn g_type_depth(p_type: usize) c_uint;
pub const typeDepth = g_type_depth;

/// Ensures that the indicated `type` has been registered with the
/// type system, and its `_class_init` method has been run.
///
/// In theory, simply calling the type's `_get_type` method (or using
/// the corresponding macro) is supposed take care of this. However,
/// `_get_type` methods are often marked `G_GNUC_CONST` for performance
/// reasons, even though this is technically incorrect (since
/// `G_GNUC_CONST` requires that the function not have side effects,
/// which `_get_type` methods do on the first call). As a result, if
/// you write a bare call to a `_get_type` macro, it may get optimized
/// out by the compiler. Using `gobject.typeEnsure` guarantees that the
/// type's `_get_type` method is called.
extern fn g_type_ensure(p_type: usize) void;
pub const typeEnsure = g_type_ensure;

/// Frees an instance of a type, returning it to the instance pool for
/// the type, if there is one.
///
/// Like `gobject.typeCreateInstance`, this function is reserved for
/// implementors of fundamental types.
extern fn g_type_free_instance(p_instance: *gobject.TypeInstance) void;
pub const typeFreeInstance = g_type_free_instance;

/// Look up the type ID from a given type name, returning 0 if no type
/// has been registered under this name (this is the preferred method
/// to find out by name whether a specific type has been registered
/// yet).
extern fn g_type_from_name(p_name: [*:0]const u8) usize;
pub const typeFromName = g_type_from_name;

/// Internal function, used to extract the fundamental type ID portion.
/// Use `G_TYPE_FUNDAMENTAL` instead.
extern fn g_type_fundamental(p_type_id: usize) usize;
pub const typeFundamental = g_type_fundamental;

/// Returns the next free fundamental type id which can be used to
/// register a new fundamental type with `gobject.typeRegisterFundamental`.
/// The returned type ID represents the highest currently registered
/// fundamental type identifier.
extern fn g_type_fundamental_next() usize;
pub const typeFundamentalNext = g_type_fundamental_next;

/// Returns the number of instances allocated of the particular type;
/// this is only available if GLib is built with debugging support and
/// the `instance-count` debug flag is set (by setting the `GOBJECT_DEBUG`
/// variable to include `instance-count`).
extern fn g_type_get_instance_count(p_type: usize) c_int;
pub const typeGetInstanceCount = g_type_get_instance_count;

/// Returns the `gobject.TypePlugin` structure for `type`.
extern fn g_type_get_plugin(p_type: usize) *gobject.TypePlugin;
pub const typeGetPlugin = g_type_get_plugin;

/// Obtains data which has previously been attached to `type`
/// with `gobject.typeSetQdata`.
///
/// Note that this does not take subtyping into account; data
/// attached to one type with `gobject.typeSetQdata` cannot
/// be retrieved from a subtype using `gobject.typeGetQdata`.
extern fn g_type_get_qdata(p_type: usize, p_quark: glib.Quark) ?*anyopaque;
pub const typeGetQdata = g_type_get_qdata;

/// Returns an opaque serial number that represents the state of the set
/// of registered types. Any time a type is registered this serial changes,
/// which means you can cache information based on type lookups (such as
/// `gobject.typeFromName`) and know if the cache is still valid at a later
/// time by comparing the current serial with the one at the type lookup.
extern fn g_type_get_type_registration_serial() c_uint;
pub const typeGetTypeRegistrationSerial = g_type_get_type_registration_serial;

/// This function used to initialise the type system.  Since GLib 2.36,
/// the type system is initialised automatically and this function does
/// nothing.
extern fn g_type_init() void;
pub const typeInit = g_type_init;

/// This function used to initialise the type system with debugging
/// flags.  Since GLib 2.36, the type system is initialised automatically
/// and this function does nothing.
///
/// If you need to enable debugging features, use the `GOBJECT_DEBUG`
/// environment variable.
extern fn g_type_init_with_debug_flags(p_debug_flags: gobject.TypeDebugFlags) void;
pub const typeInitWithDebugFlags = g_type_init_with_debug_flags;

/// Return a newly allocated and 0-terminated array of type IDs, listing
/// the interface types that `type` conforms to.
extern fn g_type_interfaces(p_type: usize, p_n_interfaces: ?*c_uint) [*]usize;
pub const typeInterfaces = g_type_interfaces;

/// If `is_a_type` is a derivable type, check whether `type` is a
/// descendant of `is_a_type`. If `is_a_type` is an interface, check
/// whether `type` conforms to it.
extern fn g_type_is_a(p_type: usize, p_is_a_type: usize) c_int;
pub const typeIsA = g_type_is_a;

/// Get the unique name that is assigned to a type ID.
///
/// Note that this function (like all other GType API) cannot cope with
/// invalid type IDs. `G_TYPE_INVALID` may be passed to this function, as
/// may be any other validly registered type ID, but randomized type IDs
/// should not be passed in and will most likely lead to a crash.
extern fn g_type_name(p_type: usize) ?[*:0]const u8;
pub const typeName = g_type_name;

extern fn g_type_name_from_class(p_g_class: *gobject.TypeClass) [*:0]const u8;
pub const typeNameFromClass = g_type_name_from_class;

extern fn g_type_name_from_instance(p_instance: *gobject.TypeInstance) [*:0]const u8;
pub const typeNameFromInstance = g_type_name_from_instance;

/// Given a `leaf_type` and a `root_type` which is contained in its
/// ancestry, return the type that `root_type` is the immediate parent
/// of. In other words, this function determines the type that is
/// derived directly from `root_type` which is also a base class of
/// `leaf_type`.  Given a root type and a leaf type, this function can
/// be used to determine the types and order in which the leaf type is
/// descended from the root type.
extern fn g_type_next_base(p_leaf_type: usize, p_root_type: usize) usize;
pub const typeNextBase = g_type_next_base;

/// Return the direct parent type of the passed in type. If the passed
/// in type has no parent, i.e. is a fundamental type, 0 is returned.
extern fn g_type_parent(p_type: usize) usize;
pub const typeParent = g_type_parent;

/// Get the corresponding quark of the type IDs name.
extern fn g_type_qname(p_type: usize) glib.Quark;
pub const typeQname = g_type_qname;

/// Queries the type system for information about a specific type.
///
/// This function will fill in a user-provided structure to hold
/// type-specific information. If an invalid `gobject.Type` is passed in, the
/// `type` member of the `gobject.TypeQuery` is 0. All members filled into the
/// `gobject.TypeQuery` structure should be considered constant and have to be
/// left untouched.
///
/// Since GLib 2.78, this function allows queries on dynamic types. Previously
/// it only supported static types.
extern fn g_type_query(p_type: usize, p_query: *gobject.TypeQuery) void;
pub const typeQuery = g_type_query;

/// Registers `type_name` as the name of a new dynamic type derived from
/// `parent_type`.  The type system uses the information contained in the
/// `gobject.TypePlugin` structure pointed to by `plugin` to manage the type and its
/// instances (if not abstract).  The value of `flags` determines the nature
/// (e.g. abstract or not) of the type.
extern fn g_type_register_dynamic(p_parent_type: usize, p_type_name: [*:0]const u8, p_plugin: *gobject.TypePlugin, p_flags: gobject.TypeFlags) usize;
pub const typeRegisterDynamic = g_type_register_dynamic;

/// Registers `type_id` as the predefined identifier and `type_name` as the
/// name of a fundamental type. If `type_id` is already registered, or a
/// type named `type_name` is already registered, the behaviour is undefined.
/// The type system uses the information contained in the `gobject.TypeInfo` structure
/// pointed to by `info` and the `gobject.TypeFundamentalInfo` structure pointed to by
/// `finfo` to manage the type and its instances. The value of `flags` determines
/// additional characteristics of the fundamental type.
extern fn g_type_register_fundamental(p_type_id: usize, p_type_name: [*:0]const u8, p_info: *const gobject.TypeInfo, p_finfo: *const gobject.TypeFundamentalInfo, p_flags: gobject.TypeFlags) usize;
pub const typeRegisterFundamental = g_type_register_fundamental;

/// Registers `type_name` as the name of a new static type derived from
/// `parent_type`. The type system uses the information contained in the
/// `gobject.TypeInfo` structure pointed to by `info` to manage the type and its
/// instances (if not abstract). The value of `flags` determines the nature
/// (e.g. abstract or not) of the type.
extern fn g_type_register_static(p_parent_type: usize, p_type_name: [*:0]const u8, p_info: *const gobject.TypeInfo, p_flags: gobject.TypeFlags) usize;
pub const typeRegisterStatic = g_type_register_static;

/// Registers `type_name` as the name of a new static type derived from
/// `parent_type`.  The value of `flags` determines the nature (e.g.
/// abstract or not) of the type. It works by filling a `gobject.TypeInfo`
/// struct and calling `gobject.typeRegisterStatic`.
extern fn g_type_register_static_simple(p_parent_type: usize, p_type_name: [*:0]const u8, p_class_size: c_uint, p_class_init: gobject.ClassInitFunc, p_instance_size: c_uint, p_instance_init: gobject.InstanceInitFunc, p_flags: gobject.TypeFlags) usize;
pub const typeRegisterStaticSimple = g_type_register_static_simple;

/// Removes a previously installed `gobject.TypeClassCacheFunc`. The cache
/// maintained by `cache_func` has to be empty when calling
/// `gobject.typeRemoveClassCacheFunc` to avoid leaks.
extern fn g_type_remove_class_cache_func(p_cache_data: ?*anyopaque, p_cache_func: gobject.TypeClassCacheFunc) void;
pub const typeRemoveClassCacheFunc = g_type_remove_class_cache_func;

/// Removes an interface check function added with
/// `gobject.typeAddInterfaceCheck`.
extern fn g_type_remove_interface_check(p_check_data: ?*anyopaque, p_check_func: gobject.TypeInterfaceCheckFunc) void;
pub const typeRemoveInterfaceCheck = g_type_remove_interface_check;

/// Attaches arbitrary data to a type.
extern fn g_type_set_qdata(p_type: usize, p_quark: glib.Quark, p_data: ?*anyopaque) void;
pub const typeSetQdata = g_type_set_qdata;

extern fn g_type_test_flags(p_type: usize, p_flags: c_uint) c_int;
pub const typeTestFlags = g_type_test_flags;

extern fn g_variant_get_gtype() usize;
pub const variantGetGtype = g_variant_get_gtype;

/// A callback function used by the type system to finalize those portions
/// of a derived types class structure that were setup from the corresponding
/// `gobject.BaseInitFunc` function.
///
/// Class finalization basically works the inverse way in which class
/// initialization is performed.
///
/// See `gobject.ClassInitFunc` for a discussion of the class initialization process.
pub const BaseFinalizeFunc = *const fn (p_g_class: *gobject.TypeClass) callconv(.c) void;

/// A callback function used by the type system to do base initialization
/// of the class structures of derived types.
///
/// This function is called as part of the initialization process of all derived
/// classes and should reallocate or reset all dynamic class members copied over
/// from the parent class.
///
/// For example, class members (such as strings) that are not sufficiently
/// handled by a plain memory copy of the parent class into the derived class
/// have to be altered. See `gobject.ClassInitFunc` for a discussion of the class
/// initialization process.
pub const BaseInitFunc = *const fn (p_g_class: *gobject.TypeClass) callconv(.c) void;

/// A function to be called to transform `from_value` to `to_value`.
///
/// If this is the `transform_to` function of a binding, then `from_value`
/// is the `source_property` on the `source` object, and `to_value` is the
/// `target_property` on the `target` object. If this is the
/// `transform_from` function of a `G_BINDING_BIDIRECTIONAL` binding,
/// then those roles are reversed.
pub const BindingTransformFunc = *const fn (p_binding: *gobject.Binding, p_from_value: *const gobject.Value, p_to_value: *gobject.Value, p_user_data: ?*anyopaque) callconv(.c) c_int;

/// This function is provided by the user and should produce a copy
/// of the passed in boxed structure.
pub const BoxedCopyFunc = *const fn (p_boxed: *anyopaque) callconv(.c) *anyopaque;

/// This function is provided by the user and should free the boxed
/// structure passed.
pub const BoxedFreeFunc = *const fn (p_boxed: *anyopaque) callconv(.c) void;

/// The type used for callback functions in structure definitions and function
/// signatures.
///
/// This doesn't mean that all callback functions must take no  parameters and
/// return void. The required signature of a callback function is determined by
/// the context in which is used (e.g. the signal to which it is connected).
///
/// Use `G_CALLBACK` to cast the callback function to a `gobject.Callback`.
pub const Callback = *const fn () callconv(.c) void;

/// A callback function used by the type system to finalize a class.
///
/// This function is rarely needed, as dynamically allocated class resources
/// should be handled by `gobject.BaseInitFunc` and `gobject.BaseFinalizeFunc`.
///
/// Also, specification of a `gobject.ClassFinalizeFunc` in the `gobject.TypeInfo`
/// structure of a static type is invalid, because classes of static types
/// will never be finalized (they are artificially kept alive when their
/// reference count drops to zero).
pub const ClassFinalizeFunc = *const fn (p_g_class: *gobject.TypeClass, p_class_data: ?*anyopaque) callconv(.c) void;

/// A callback function used by the type system to initialize the class
/// of a specific type.
///
/// This function should initialize all static class members.
///
/// The initialization process of a class involves:
///
/// - Copying common members from the parent class over to the
///   derived class structure.
/// - Zero initialization of the remaining members not copied
///   over from the parent class.
/// - Invocation of the `gobject.BaseInitFunc` initializers of all parent
///   types and the class' type.
/// - Invocation of the class' `gobject.ClassInitFunc` initializer.
///
/// Since derived classes are partially initialized through a memory copy
/// of the parent class, the general rule is that `gobject.BaseInitFunc` and
/// `gobject.BaseFinalizeFunc` should take care of necessary reinitialization
/// and release of those class members that were introduced by the type
/// that specified these `gobject.BaseInitFunc`/`gobject.BaseFinalizeFunc`.
/// `gobject.ClassInitFunc` should only care about initializing static
/// class members, while dynamic class members (such as allocated strings
/// or reference counted resources) are better handled by a `gobject.BaseInitFunc`
/// for this type, so proper initialization of the dynamic class members
/// is performed for class initialization of derived types as well.
///
/// An example may help to correspond the intend of the different class
/// initializers:
///
/// ```
/// typedef struct {
///   GObjectClass parent_class;
///   gint         static_integer;
///   gchar       *dynamic_string;
/// } TypeAClass;
/// static void
/// type_a_base_class_init (TypeAClass *class)
/// {
///   class->dynamic_string = g_strdup ("some string");
/// }
/// static void
/// type_a_base_class_finalize (TypeAClass *class)
/// {
///   g_free (class->dynamic_string);
/// }
/// static void
/// type_a_class_init (TypeAClass *class)
/// {
///   class->static_integer = 42;
/// }
///
/// typedef struct {
///   TypeAClass   parent_class;
///   gfloat       static_float;
///   GString     *dynamic_gstring;
/// } TypeBClass;
/// static void
/// type_b_base_class_init (TypeBClass *class)
/// {
///   class->dynamic_gstring = g_string_new ("some other string");
/// }
/// static void
/// type_b_base_class_finalize (TypeBClass *class)
/// {
///   g_string_free (class->dynamic_gstring);
/// }
/// static void
/// type_b_class_init (TypeBClass *class)
/// {
///   class->static_float = 3.14159265358979323846;
/// }
/// ```
///
/// Initialization of TypeBClass will first cause initialization of
/// TypeAClass (derived classes reference their parent classes, see
/// `gobject.typeClassRef` on this).
///
/// Initialization of TypeAClass roughly involves zero-initializing its fields,
/// then calling its `gobject.BaseInitFunc` `type_a_base_class_init` to allocate
/// its dynamic members (dynamic_string), and finally calling its `gobject.ClassInitFunc`
/// `type_a_class_init` to initialize its static members (static_integer).
/// The first step in the initialization process of TypeBClass is then
/// a plain memory copy of the contents of TypeAClass into TypeBClass and
/// zero-initialization of the remaining fields in TypeBClass.
/// The dynamic members of TypeAClass within TypeBClass now need
/// reinitialization which is performed by calling `type_a_base_class_init`
/// with an argument of TypeBClass.
///
/// After that, the `gobject.BaseInitFunc` of TypeBClass, `type_b_base_class_init`
/// is called to allocate the dynamic members of TypeBClass (dynamic_gstring),
/// and finally the `gobject.ClassInitFunc` of TypeBClass, `type_b_class_init`,
/// is called to complete the initialization process with the static members
/// (static_float).
///
/// Corresponding finalization counter parts to the `gobject.BaseInitFunc` functions
/// have to be provided to release allocated resources at class finalization
/// time.
pub const ClassInitFunc = *const fn (p_g_class: *gobject.TypeClass, p_class_data: ?*anyopaque) callconv(.c) void;

/// The type used for marshaller functions.
pub const ClosureMarshal = *const fn (p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_n_param_values: c_uint, p_param_values: [*]const gobject.Value, p_invocation_hint: ?*anyopaque, p_marshal_data: ?*anyopaque) callconv(.c) void;

/// The type used for the various notification callbacks which can be registered
/// on closures.
pub const ClosureNotify = *const fn (p_data: ?*anyopaque, p_closure: *anyopaque) callconv(.c) void;

/// A callback function used by the type system to initialize a new
/// instance of a type.
///
/// This function initializes all instance members and allocates any resources
/// required by it.
///
/// Initialization of a derived instance involves calling all its parent
/// types instance initializers, so the class member of the instance
/// is altered during its initialization to always point to the class that
/// belongs to the type the current initializer was introduced for.
///
/// The extended members of `instance` are guaranteed to have been filled with
/// zeros before this function is called.
pub const InstanceInitFunc = *const fn (p_instance: *gobject.TypeInstance, p_g_class: *gobject.TypeClass) callconv(.c) void;

/// A callback function used by the type system to finalize an interface.
///
/// This function should destroy any internal data and release any resources
/// allocated by the corresponding `gobject.InterfaceInitFunc` function.
pub const InterfaceFinalizeFunc = *const fn (p_g_iface: *gobject.TypeInterface, p_iface_data: ?*anyopaque) callconv(.c) void;

/// A callback function used by the type system to initialize a new
/// interface.
///
/// This function should initialize all internal data and* allocate any
/// resources required by the interface.
///
/// The members of `iface_data` are guaranteed to have been filled with
/// zeros before this function is called.
pub const InterfaceInitFunc = *const fn (p_g_iface: *gobject.TypeInterface, p_iface_data: ?*anyopaque) callconv(.c) void;

/// The type of the `finalize` function of `gobject.ObjectClass`.
pub const ObjectFinalizeFunc = *const fn (p_object: *gobject.Object) callconv(.c) void;

/// The type of the `get_property` function of `gobject.ObjectClass`.
pub const ObjectGetPropertyFunc = *const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void;

/// The type of the `set_property` function of `gobject.ObjectClass`.
pub const ObjectSetPropertyFunc = *const fn (p_object: *gobject.Object, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) callconv(.c) void;

/// The signal accumulator is a special callback function that can be used
/// to collect return values of the various callbacks that are called
/// during a signal emission.
///
/// The signal accumulator is specified at signal creation time, if it is
/// left `NULL`, no accumulation of callback return values is performed.
/// The return value of signal emissions is then the value returned by the
/// last callback.
pub const SignalAccumulator = *const fn (p_ihint: *gobject.SignalInvocationHint, p_return_accu: *gobject.Value, p_handler_return: *const gobject.Value, p_data: ?*anyopaque) callconv(.c) c_int;

/// A simple function pointer to get invoked when the signal is emitted.
///
/// Emission hooks allow you to tie a hook to the signal type, so that it will
/// trap all emissions of that signal, from any object.
///
/// You may not attach these to signals created with the `G_SIGNAL_NO_HOOKS` flag.
pub const SignalEmissionHook = *const fn (p_ihint: *gobject.SignalInvocationHint, p_n_param_values: c_uint, p_param_values: [*]const gobject.Value, p_data: ?*anyopaque) callconv(.c) c_int;

/// A callback function used for notification when the state
/// of a toggle reference changes.
///
/// See also: `gobject.Object.addToggleRef`
pub const ToggleNotify = *const fn (p_data: ?*anyopaque, p_object: *gobject.Object, p_is_last_ref: c_int) callconv(.c) void;

/// A callback function which is called when the reference count of a class
/// drops to zero.
///
/// It may use `gobject.typeClassRef` to prevent the class from being freed. You
/// should not call `gobject.TypeClass.unref` from a `gobject.TypeClassCacheFunc` function
/// to prevent infinite recursion, use `gobject.TypeClass.unrefUncached` instead.
///
/// The functions have to check the class id passed in to figure
/// whether they actually want to cache the class of this type, since all
/// classes are routed through the same `gobject.TypeClassCacheFunc` chain.
pub const TypeClassCacheFunc = *const fn (p_cache_data: ?*anyopaque, p_g_class: *gobject.TypeClass) callconv(.c) c_int;

/// A callback called after an interface vtable is initialized.
///
/// See `gobject.typeAddInterfaceCheck`.
pub const TypeInterfaceCheckFunc = *const fn (p_check_data: ?*anyopaque, p_g_iface: *gobject.TypeInterface) callconv(.c) void;

/// The type of the `complete_interface_info` function of `gobject.TypePluginClass`.
pub const TypePluginCompleteInterfaceInfo = *const fn (p_plugin: *gobject.TypePlugin, p_instance_type: usize, p_interface_type: usize, p_info: *gobject.InterfaceInfo) callconv(.c) void;

/// The type of the `complete_type_info` function of `gobject.TypePluginClass`.
pub const TypePluginCompleteTypeInfo = *const fn (p_plugin: *gobject.TypePlugin, p_g_type: usize, p_info: *gobject.TypeInfo, p_value_table: *gobject.TypeValueTable) callconv(.c) void;

/// The type of the `unuse_plugin` function of `gobject.TypePluginClass`.
pub const TypePluginUnuse = *const fn (p_plugin: *gobject.TypePlugin) callconv(.c) void;

/// The type of the `use_plugin` function of `gobject.TypePluginClass`, which gets called
/// to increase the use count of `plugin`.
pub const TypePluginUse = *const fn (p_plugin: *gobject.TypePlugin) callconv(.c) void;

/// This function is responsible for converting the values collected from
/// a variadic argument list into contents suitable for storage in a `gobject.Value`.
///
/// This function should setup `value` similar to `gobject.TypeValueInitFunc`; e.g.
/// for a string value that does not allow `NULL` pointers, it needs to either
/// emit an error, or do an implicit conversion by storing an empty string.
///
/// The `value` passed in to this function has a zero-filled data array, so
/// just like for `gobject.TypeValueInitFunc` it is guaranteed to not contain any old
/// contents that might need freeing.
///
/// The `n_collect_values` argument is the string length of the `collect_format`
/// field of `gobject.TypeValueTable`, and `collect_values` is an array of `gobject.TypeCValue`
/// with length of `n_collect_values`, containing the collected values according
/// to `collect_format`.
///
/// The `collect_flags` argument provided as a hint by the caller. It may
/// contain the flag `G_VALUE_NOCOPY_CONTENTS` indicating that the collected
/// value contents may be considered ‘static’ for the duration of the `value`
/// lifetime. Thus an extra copy of the contents stored in `collect_values` is
/// not required for assignment to `value`.
///
/// For our above string example, we continue with:
///
/// ```
/// if (!collect_values[0].v_pointer)
///   value->data[0].v_pointer = g_strdup ("");
/// else if (collect_flags & G_VALUE_NOCOPY_CONTENTS)
///   {
///     value->data[0].v_pointer = collect_values[0].v_pointer;
///     // keep a flag for the `value_free` implementation to not free this string
///     value->data[1].v_uint = G_VALUE_NOCOPY_CONTENTS;
///   }
/// else
///   value->data[0].v_pointer = g_strdup (collect_values[0].v_pointer);
/// return NULL;
/// ```
///
/// It should be noted, that it is generally a bad idea to follow the
/// `G_VALUE_NOCOPY_CONTENTS` hint for reference counted types. Due to
/// reentrancy requirements and reference count assertions performed
/// by the signal emission code, reference counts should always be
/// incremented for reference counted contents stored in the `value->data`
/// array. To deviate from our string example for a moment, and taking
/// a look at an exemplary implementation for `GTypeValueTable.`collect_value``
/// of `GObject`:
///
/// ```
/// GObject *object = G_OBJECT (collect_values[0].v_pointer);
/// g_return_val_if_fail (object != NULL,
///    g_strdup_printf ("Object `p` passed as invalid NULL pointer", object));
/// // never honour G_VALUE_NOCOPY_CONTENTS for ref-counted types
/// value->data[0].v_pointer = g_object_ref (object);
/// return NULL;
/// ```
///
/// The reference count for valid objects is always incremented, regardless
/// of `collect_flags`. For invalid objects, the example returns a newly
/// allocated string without altering `value`.
///
/// Upon success, ``collect_value`` needs to return `NULL`. If, however,
/// an error condition occurred, ``collect_value`` should return a newly
/// allocated string containing an error diagnostic.
///
/// The calling code makes no assumptions about the `value` contents being
/// valid upon error returns, `value` is simply thrown away without further
/// freeing. As such, it is a good idea to not allocate `GValue` contents
/// prior to returning an error; however, ``collect_values`` is not obliged
/// to return a correctly setup `value` for error returns, simply because
/// any non-`NULL` return is considered a fatal programming error, and
/// further program behaviour is undefined.
pub const TypeValueCollectFunc = *const fn (p_value: *gobject.Value, p_n_collect_values: c_uint, p_collect_values: [*]gobject.TypeCValue, p_collect_flags: c_uint) callconv(.c) ?[*:0]u8;

/// Copies the content of a `gobject.Value` into another.
///
/// The `dest_value` is a `gobject.Value` with zero-filled data section and `src_value`
/// is a properly initialized `gobject.Value` of same type, or derived type.
///
/// The purpose of this function is to copy the contents of `src_value`
/// into `dest_value` in a way, that even after `src_value` has been freed, the
/// contents of `dest_value` remain valid. String type example:
///
/// ```
/// dest_value->data[0].v_pointer = g_strdup (src_value->data[0].v_pointer);
/// ```
pub const TypeValueCopyFunc = *const fn (p_src_value: *const gobject.Value, p_dest_value: *gobject.Value) callconv(.c) void;

/// Frees any old contents that might be left in the `value->data` array of
/// the given value.
///
/// No resources may remain allocated through the `gobject.Value` contents after this
/// function returns. E.g. for our above string type:
///
/// ```
/// // only free strings without a specific flag for static storage
/// if (!(value->data[1].v_uint & G_VALUE_NOCOPY_CONTENTS))
///   g_free (value->data[0].v_pointer);
/// ```
pub const TypeValueFreeFunc = *const fn (p_value: *gobject.Value) callconv(.c) void;

/// Initializes the value contents by setting the fields of the `value->data`
/// array.
///
/// The data array of the `gobject.Value` passed into this function was zero-filled
/// with ``memset``, so no care has to be taken to free any old contents.
/// For example, in the case of a string value that may never be `NULL`, the
/// implementation might look like:
///
/// ```
/// value->data[0].v_pointer = g_strdup ("");
/// ```
pub const TypeValueInitFunc = *const fn (p_value: *gobject.Value) callconv(.c) void;

/// This function is responsible for storing the `value`
/// contents into arguments passed through a variadic argument list which
/// got collected into `collect_values` according to `lcopy_format`.
///
/// The `n_collect_values` argument equals the string length of
/// `lcopy_format`, and `collect_flags` may contain `G_VALUE_NOCOPY_CONTENTS`.
///
/// In contrast to `gobject.TypeValueCollectFunc`, this function is obliged to always
/// properly support `G_VALUE_NOCOPY_CONTENTS`.
///
/// Similar to `gobject.TypeValueCollectFunc` the function may prematurely abort by
/// returning a newly allocated string describing an error condition. To
/// complete the string example:
///
/// ```
/// gchar **string_p = collect_values[0].v_pointer;
/// g_return_val_if_fail (string_p != NULL,
///   g_strdup ("string location passed as NULL"));
///
/// if (collect_flags & G_VALUE_NOCOPY_CONTENTS)
///   *string_p = value->data[0].v_pointer;
/// else
///   *string_p = g_strdup (value->data[0].v_pointer);
/// ```
///
/// And an illustrative version of this function for reference-counted
/// types:
///
/// ```
/// GObject **object_p = collect_values[0].v_pointer;
/// g_return_val_if_fail (object_p != NULL,
///   g_strdup ("object location passed as NULL"));
///
/// if (value->data[0].v_pointer == NULL)
///   *object_p = NULL;
/// else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) // always honour
///   *object_p = value->data[0].v_pointer;
/// else
///   *object_p = g_object_ref (value->data[0].v_pointer);
///
/// return NULL;
/// ```
pub const TypeValueLCopyFunc = *const fn (p_value: *const gobject.Value, p_n_collect_values: c_uint, p_collect_values: [*]gobject.TypeCValue, p_collect_flags: c_uint) callconv(.c) ?[*:0]u8;

/// If the value contents fit into a pointer, such as objects or strings,
/// return this pointer, so the caller can peek at the current contents.
///
/// To extend on our above string example:
///
/// ```
/// return value->data[0].v_pointer;
/// ```
pub const TypeValuePeekPointerFunc = *const fn (p_value: *const gobject.Value) callconv(.c) ?*anyopaque;

/// This is the signature of va_list marshaller functions, an optional
/// marshaller that can be used in some situations to avoid
/// marshalling the signal argument into GValues.
pub const VaClosureMarshal = *const fn (p_closure: *gobject.Closure, p_return_value: ?*gobject.Value, p_instance: *gobject.TypeInstance, p_args: std.builtin.VaList, p_marshal_data: ?*anyopaque, p_n_params: c_int, p_param_types: [*]usize) callconv(.c) void;

/// The type of value transformation functions which can be registered with
/// `gobject.valueRegisterTransformFunc`.
///
/// `dest_value` will be initialized to the correct destination type.
pub const ValueTransform = *const fn (p_src_value: *const gobject.Value, p_dest_value: *gobject.Value) callconv(.c) void;

/// A `gobject.WeakNotify` function can be added to an object as a callback that gets
/// triggered when the object is finalized.
///
/// Since the object is already being disposed when the `gobject.WeakNotify` is called,
/// there's not much you could do with the object, apart from e.g. using its
/// address as hash-index or the like.
///
/// In particular, this means it’s invalid to call `gobject.Object.ref`,
/// `gobject.WeakRef.init`, `gobject.WeakRef.set`, `gobject.Object.addToggleRef`,
/// `gobject.Object.weakRef`, `gobject.Object.addWeakPointer` or any function which calls
/// them on the object from this callback.
pub const WeakNotify = *const fn (p_data: ?*anyopaque, p_where_the_object_was: *gobject.Object) callconv(.c) void;

/// Mask containing the bits of `gobject.ParamSpec.flags` which are reserved for GLib.
pub const PARAM_MASK = 255;
/// `gobject.ParamFlags` value alias for `G_PARAM_STATIC_NAME` | `G_PARAM_STATIC_NICK` | `G_PARAM_STATIC_BLURB`.
///
/// It is recommended to use this for all properties by default, as it allows for
/// internal performance improvements in GObject.
///
/// It is very rare that a property would have a dynamically constructed name,
/// nickname or blurb.
///
/// Since 2.13.0
pub const PARAM_STATIC_STRINGS = 224;
/// Minimum shift count to be used for user defined flags, to be stored in
/// `gobject.ParamSpec.flags`. The maximum allowed is 10.
pub const PARAM_USER_SHIFT = 8;
/// A mask for all `gobject.SignalFlags` bits.
pub const SIGNAL_FLAGS_MASK = 511;
/// A mask for all `gobject.SignalMatchType` bits.
pub const SIGNAL_MATCH_MASK = 63;
/// A bit in the type number that's supposed to be left untouched.
pub const TYPE_FLAG_RESERVED_ID_BIT = 1;
/// An integer constant that represents the number of identifiers reserved
/// for types that are assigned at compile-time.
pub const TYPE_FUNDAMENTAL_MAX = 1020;
/// Shift value used in converting numbers to type IDs.
pub const TYPE_FUNDAMENTAL_SHIFT = 2;
/// First fundamental type number to create a new fundamental type id with
/// `G_TYPE_MAKE_FUNDAMENTAL` reserved for BSE.
pub const TYPE_RESERVED_BSE_FIRST = 32;
/// Last fundamental type number reserved for BSE.
pub const TYPE_RESERVED_BSE_LAST = 48;
/// First fundamental type number to create a new fundamental type id with
/// `G_TYPE_MAKE_FUNDAMENTAL` reserved for GLib.
pub const TYPE_RESERVED_GLIB_FIRST = 22;
/// Last fundamental type number reserved for GLib.
pub const TYPE_RESERVED_GLIB_LAST = 31;
/// First available fundamental type number to create new fundamental
/// type id with `G_TYPE_MAKE_FUNDAMENTAL`.
pub const TYPE_RESERVED_USER_FIRST = 49;
/// The maximal number of `GTypeCValues` which can be collected for a
/// single `gobject.Value`.
pub const VALUE_COLLECT_FORMAT_MAX_LENGTH = 8;
/// For string values, indicates that the string contained is canonical and will
/// exist for the duration of the process. See `gobject.Value.setInternedString`.
pub const VALUE_INTERNED_STRING = 268435456;
/// If passed to `G_VALUE_COLLECT`, allocated data won't be copied
/// but used verbatim. This does not affect ref-counted types like
/// objects. This does not affect usage of `gobject.Value.copy`, the data will
/// be copied if it is not ref-counted.
pub const VALUE_NOCOPY_CONTENTS = 134217728;

test {
    @setEvalBranchQuota(100_000);
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(ext);
}
