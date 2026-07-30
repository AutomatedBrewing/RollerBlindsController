/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_LIBS_UTILS_UTILS_H_
#define SRC_MODULES_LIBS_UTILS_UTILS_H_

/* Private includes ----------------------------------------------------------*/
#include <inttypes.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/

#define BIT(n) (1 << (n))

/**
 * @brief Macro for getting the number of elements in an array.
 *
 * @param[in] array Name of the array.
 *
 * @return Array element count.
 */
#define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))

/**@brief Container of macro (borrowed from Linux kernel).
 *
 * This macro returns parent structure address basing on child member address.
 *
 * @param ptr       Address of child type.
 * @param type      Type of parent structure.
 * @param member    Name of child field in parent structure.
 *
 * @return Parent structure address.
 * */
#define CONTAINER_OF(ptr, type, member) (type *)((char *)ptr - offsetof(type, member))

/**
 * @brief Value of @p x rounded up to the next multiple of @p align,
 *        which must be a power of 2.
 */
#define ROUND_UP(x, align) (((unsigned long)(x) + ((unsigned long)(align)-1)) & ~((unsigned long)(align)-1))

/**
 * @brief Value of @p x rounded down to the previous multiple of @p
 *        align, which must be a power of 2.
 */
#define ROUND_DOWN(x, align) ((unsigned long)(x) & ~((unsigned long)(align)-1))

/** @brief Value of @p x rounded up to the next word boundary. */
#define WB_UP(x) ROUND_UP(x, sizeof(void *))

/** @brief Value of @p x rounded down to the previous word boundary. */
#define WB_DN(x) ROUND_DOWN(x, sizeof(void *))

/**
 * @def MAX
 * @brief The larger value between @p a and @p b.
 * @note Arguments are evaluated twice.
 */
#ifndef MAX
/* Use Z_MAX for a GCC-only, single evaluation version */
#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#endif

/**
 * @def MIN
 * @brief The smaller value between @p a and @p b.
 * @note Arguments are evaluated twice.
 */
#ifndef MIN
/* Use Z_MIN for a GCC-only, single evaluation version */
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#endif

/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
/**@brief Function for encoding a uint16 value.
 *
 * @param[in]   value            Value to be encoded.
 * @param[out]  p_encoded_data   Buffer where the encoded data is to be written.
 *
 * @return      Number of bytes written.
 */
static inline uint8_t uint16_encode(uint16_t value, uint8_t *p_encoded_data)
{
    p_encoded_data[0] = (uint8_t)((value & 0x00FF) >> 0);
    p_encoded_data[1] = (uint8_t)((value & 0xFF00) >> 8);
    return sizeof(uint16_t);
}

/**@brief Function for encoding a uint32 value.
 *
 * @param[in]   value            Value to be encoded.
 * @param[out]  p_encoded_data   Buffer where the encoded data is to be written.
 *
 * @return      Number of bytes written.
 */
static inline uint8_t uint32_encode(uint32_t value, uint8_t *p_encoded_data)
{
    p_encoded_data[0] = (uint8_t)((value & 0x000000FF) >> 0);
    p_encoded_data[1] = (uint8_t)((value & 0x0000FF00) >> 8);
    p_encoded_data[2] = (uint8_t)((value & 0x00FF0000) >> 16);
    p_encoded_data[3] = (uint8_t)((value & 0xFF000000) >> 24);
    return sizeof(uint32_t);
}

/**@brief Function for decoding a uint16 value.
 *
 * @param[in]   p_encoded_data   Buffer where the encoded data is stored.
 *
 * @return      Decoded value.
 */
static inline uint16_t uint16_decode(uint8_t *p_encoded_data)
{
    return (uint16_t)((((uint16_t)((uint8_t *)p_encoded_data)[0])) | (((uint16_t)((uint8_t *)p_encoded_data)[1]) << 8));
}

/**@brief Function for decoding a uint32 value.
 *
 * @param[in]   p_encoded_data   Buffer where the encoded data is stored.
 *
 * @return      Decoded value.
 */
static inline uint32_t uint32_decode(uint8_t *p_encoded_data)
{
    return ((((uint32_t)((uint8_t *)p_encoded_data)[0]) << 0) | (((uint32_t)((uint8_t *)p_encoded_data)[1]) << 8) |
            (((uint32_t)((uint8_t *)p_encoded_data)[2]) << 16) | (((uint32_t)((uint8_t *)p_encoded_data)[3]) << 24));
}

/**@brief Function for checking if a pointer value is aligned to a 4 byte boundary.
 *
 * @param[in]   p   Pointer value to be checked.
 *
 * @return      TRUE if pointer is aligned to a 4 byte boundary, FALSE otherwise.
 */
static inline uint8_t is_word_aligned(void const *p)
{
    return (((uintptr_t)p & 0x03) == 0);
}

#endif /* SRC_MODULES_LIBS_UTILS_UTILS_H_ */
